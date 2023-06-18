from fastapi import FastAPI
from typing import Dict
import json
import random

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello, FastAPI!"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)

@app.get("/rec/{category}")
def find_ids_by_category(category: str):
    with open('lecture_total.json') as file:
        data = json.load(file)

    ids = [item['id'] for item in data if item['category'] == category]

    random_ids = random.sample(ids, min(5, len(ids)))

    return random_ids


@app.get("/category/{a}/{b}")
def get_lectures(a: int, b: int):
    with open('lecture_total.json', 'r') as json_file:
        lecture_data = json.load(json_file)

    lectures = [lecture_data[i] for i in range(a, b+1)]

    result = [{'id': lecture['id'], 'category': lecture['category']} for lecture in lectures]

    return result
