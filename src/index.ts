import * as sqlite from 'sqlite';
import * as express from 'express';
import * as graphqlHTTP from 'express-graphql';
import {
  buildSchema,
} from 'graphql';

const swSDL = `
  type Query {
    person(personID: ID!): Person
  }

  type Person {
    name: String
    height: Int
    mass: Float
    hair_color: String
    skin_color: String
    eye_color: String
    gender: String
    homeworld: Planet
  }

  type Planet {
    name: String
    residents: [Person!]
  }
`;

class Query {
  async person(args, db) {
    const { personID } = args;
    const rows = await db.all(`SELECT * FROM person WHERE id = ${personID}`);
    if (rows.length === 0) {
      throw new Error(`Unknown person with personID: ${personID}`);
    }
    return new Person(rows[0]);
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

  async homeworld(_, db) {
    const rows = await db.all(`SELECT * FROM planet WHERE id = ${this._homeworld}`);
    return (rows.length === 0) ? null : new Planet(rows[0]);
  }
}

class Planet {
  constructor(row) {
    this.id = row.id;
    this.name = row.name;
  }

  async residents(_, db) {
    const rows = await db.all(`SELECT * FROM person WHERE homeworld = ${this.id}`);
    return (rows.length === 0) ? null : rows.map(row => new Person(row));
  }
}

async function main() {
  const port = 8888;
  const db = await sqlite.open('./sw.sqlite3', { Promise });
  const app = express();
  app.use('/graphql', graphqlHTTP({
    schema: buildSchema(swSDL),
    rootValue: new Query(),
    context: db,
    graphiql: true,
  }));
  app.listen(port);

  console.log(`http://localhost:${port}/graphql`);
}

main().catch((err) => {
  console.error(err);
});
