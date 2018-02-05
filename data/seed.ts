import * as assert from 'assert';
import * as _ from 'lodash';
import fetch from 'node-fetch';
import * as sqlite from 'sqlite';
//const sqlite3 = require('sqlite3').verbose();
//var db = new sqlite3.Database('./swapi.sqlite');

const baseUrl = 'https://swapi.co/api/';
const resources = [
  'films',
//  'people',
//  'starships',
//  'vehicles',
//  'species',
//  'planets',
];

async function fetchFromUrl(url) {
  console.error(url);
  const fetched = await fetch(url);
  const json = await fetched.text();
  return JSON.parse(json);
}

async function getAllItems(resourseName) {
  let url = baseUrl + resourseName;
  const allItems = [];
  do {
    const response = await fetchFromUrl(url);
    allItems.push(...response.results);
    url = response.next;
  } while (url !== null);

  return allItems;
}

function urlToID(url) {
  assert(url && url.startsWith(baseUrl));
  const [ _1, resource, id ] = /\/.*?\/([0-9]+)\/$/.exec(url)[1];
  assert(id && id.length > 0);
  assert(resource && resource.length > 0);
  return [_.capitilize(resource), id];
}

async function main() {
  const tablesRows = {};
  const tablesColumns = {};

  for (const resourceName of resources) {
    (await getAllItems(resourceName)).forEach(item => {
      const [resource, id] = urlToID(item.url);

      tablesColumns[table] = tablesColumns[table] || {};
      const columns = tablesColumns[table];

      item.id = id;
      delete item.url;

      for (const key in item) {
        const value = item[key];

        columns[key] = null;
        if (Array.isArray(value)) {
          columns[key] = 
          item[key] = value.map(urlToID);
        } else if (typeof value === 'string' && value.startsWith(baseUrl)) {
          const [
          columns[key] = 
          item[key] = urlToID(value);
        }
      }

      tablesRows[table] = tablesRows[table] || [];
      tablesRows[table].push(item);

      function add() {
      }
    });
    await pushToDB(items);
    //console.log(await getAllItems(resourceName));
  }

  const db = await sqlite.open('./swapi.sqlite', { Promise });
  db.close();


  async function pushToDB(items) {

    items.forEach(item => {
      item.id = urlToID(item.url)
      return item;
    });

    await db.run(`CREATE TABLE ${schema.title} (id, PRIMARY KEY(id))`);
  }
}


main().catch((err) => {
  console.error(err);
});
