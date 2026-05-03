from fastapi import FastAPI, UploadFile
import shutil

from app.rag_pipeline import build_pipeline
from app.generator import generate_answer

app = FastAPI(title="Agentic RAG Pipeline", 
              description="Agentic Rag Pipeline With Fast API (pdf + Images + Re-ranking)",
              version="1.0.0")
agent = None

tags_metadata = [
    {
        "name": "Home",
        "description": "Welcome endpoint",
    },
    {
        "name": "Document Upload",
        "description": "Upload PDF or files for processing",
    },
    {
        "name": "Query Engine",
        "description": "Ask questions from uploaded documents",
    },
]

@app.get("/", tags=["Home"])
def home():
    return {"message": "Welcome to Agentic RAG Pipeline"}

@app.post("/upload", tags=["Document Upload"])
async def upload_pdf(file: UploadFile):
    global agent

    path = f"data/{file.filename}"

    with open(path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    agent = build_pipeline(path)

    return {"status": "PDF processed"}

@app.get("/query", tags=["Query Engine"])
def query(query: str):
    if agent is None:
        return {"error": "Please upload a PDF first"}
    
    docs = agent.run(query)
    answer = generate_answer(query, docs)
    return {"answer": answer}