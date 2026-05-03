from fastapi import FastAPI, UploadFile
import shutil

from app.rag_pipeline import build_pipeline
from app.generator import generate_answer

app = FastAPI()
agent = None


@app.post("/upload")
async def upload_pdf(file: UploadFile):
    global agent

    path = f"data/{file.filename}"

    with open(path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    agent = build_pipeline(path)

    return {"status": "PDF processed"}


@app.get("/query")
def query(query: str):
    docs = agent.run(query)
    answer = generate_answer(query, docs)
    return {"answer": answer}