import * as sqlite from 'sqlite';
import * as express from 'express';
import * as graphqlHTTP from 'express-graphql';
import { buildSchema } from 'graphql';

const SW_SDL = `
  type Query {
    person(personID: ID!): Person
  }

  type Person {
    name: String
    height: Int
    mass: Float
    hairColor: String
    skinColor: String
    eyeColor: String
    gender: String
    homeworld: Planet
  }

  type Planet {
    name: String
    residents: [Person!]
  }
`;

class Query {
  async person(args, context) {
    const row = await context.db.get(
      'SELECT * FROM person WHERE id = ?',
      args.personID,
    );
    if (!row) {
      throw new Error(`Unknown personID`);
    }
    return new Person(row);
  }
}

class Person {
  constructor(row) {
    this.name = row.name;
    this.height = row.height;
    this.mass = row.mass;
    this.hairColor = row.hair_color;
    this.skinColor = row.skin_color;
    this.eyeColor = row.eye_color;
    this.gender = row.gender;
    this._homeworld = row.homeworld;
  }

  async homeworld(_, context) {
    const row = await context.db.get(
      'SELECT * FROM planet WHERE id = ?',
      this._homeworld,
    );
    return new Planet(row);
  }
}

class Planet {
  constructor(row) {
    this.id = row.id;
    this.name = row.name;
  }

  async residents(_, context) {
    const rows = await context.db.all(
      'SELECT * FROM person WHERE homeworld = ?',
      this.id,
    );
    return rows.map(row => new Person(row));
  }
}

async function main() {
  const port = 8888;
  const db = await sqlite.open('./sw.sqlite3', { Promise });
  const app = express();
  app.use('/graphql', graphqlHTTP({
    schema: buildSchema(SW_SDL),
    rootValue: new Query(),
    context: { db },
    graphiql: true,
  }));
  app.listen(8888);

  console.log('http://localhost:8888/graphql');
}

main().catch((err) => {
  console.error(err);
});
