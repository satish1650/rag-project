Agentic Rag Pipeline With Fast Api (pdf + Images + Re-ranking)
📚 Agentic RAG Pipeline with FastAPI (Full Project Based on OpenAI)
This project demonstrates a production-style Agentic RAG pipeline using:

    FastAPI
    OpenAI embeddings + LLM
    PDF parsing (including images via OCR)
    Vector DB (FAISS)
    Re-ranking
    Agentic query orchestration

🧠 Architecture Overview
User Query → Agent → Retriever → Re-ranker → Context Builder → LLM → Response
PDF → Loader → Chunking → Embeddings → Vector Store (FAISS)

📁 Project Structure
rag-project/
│
├── app/
│   ├── main.py
│   ├── rag_pipeline.py
│   ├── agent.py
│   ├── retriever.py
│   ├── reranker.py
│   ├── pdf_processor.py
│   ├── embeddings.py
│   └── config.py
|   └── generator.py
|   └── chunking.py
│
├── data/
│   └── sample.pdf
│
├── vectorstore/
│
├── requirements.txt
├── Dockerfile
└── README.md

⚙️ Step 1: requirements.txt
fastapi
uvicorn
pydantic
python-dotenv
openai
faiss-cpu
langchain
langchain-community
pypdf
pytesseract
pdf2image
Pillow
numpy
scikit-learn

🔑 Step 2: config.py
import os
from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
EMBED_MODEL = "text-embedding-3-small"
LLM_MODEL = "gpt-4o-mini"
VECTOR_PATH = "vectorstore/index.faiss"

📄 Step 3: PDF Processor (text + image OCR)
from pypdf import PdfReader
from pdf2image import convert_from_path
import pytesseract


def extract_text_from_pdf(path):
    reader = PdfReader(path)
    text = ""
    for page in reader.pages:
        text += page.extract_text() or ""
    return text


def extract_images_text(path):
    images = convert_from_path(path)
    text = ""
    for img in images:
        text += pytesseract.image_to_string(img)
    return text


def process_pdf(path):
    text = extract_text_from_pdf(path)
    ocr_text = extract_images_text(path)
    return text + "\n" + ocr_text

🔗 Step 4: Embeddings
from openai import OpenAI
from app.config import OPENAI_API_KEY, EMBED_MODEL

client = OpenAI(api_key=OPENAI_API_KEY)


def get_embeddings(texts):
    response = client.embeddings.create(
        model=EMBED_MODEL,
        input=texts
    )
    return [e.embedding for e in response.data]

📦 Step 5: Retriever (FAISS)
import faiss
import numpy as np

class VectorStore:
    def __init__(self, dim):
        self.index = faiss.IndexFlatL2(dim)
        self.texts = []

    def add(self, embeddings, texts):
        self.index.add(np.array(embeddings).astype('float32'))
        self.texts.extend(texts)

    def search(self, query_embedding, k=5):
        D, I = self.index.search(np.array([query_embedding]).astype('float32'), k)
        return [self.texts[i] for i in I[0]]

✂️ Step 6: Chunking
def chunk_text(text, chunk_size=500):
    return [text[i:i+chunk_size] for i in range(0, len(text), chunk_size)]

🧮 Step 7: Re-ranker
from sklearn.metrics.pairwise import cosine_similarity

def rerank(query_emb, docs, doc_embs):
    scores = cosine_similarity([query_emb], doc_embs)[0]
    ranked = sorted(zip(docs, scores), key=lambda x: x[1], reverse=True)
    return [doc for doc, _ in ranked]

🤖 Step 8: Agent (Agentic RAG Logic)
from app.embeddings import get_embeddings

class RAGAgent:
    def __init__(self, retriever, reranker):
        self.retriever = retriever
        self.reranker = reranker

    def run(self, query):
        query_emb = get_embeddings([query])[0]

        docs = self.retriever.search(query_emb, k=10)
        doc_embs = get_embeddings(docs)

        reranked = self.reranker(query_emb, docs, doc_embs)

        return reranked[:5]

🧠 Step 9: LLM Response Generator
from openai import OpenAI
from app.config import OPENAI_API_KEY, LLM_MODEL

client = OpenAI(api_key=OPENAI_API_KEY)


def generate_answer(query, context_docs):
    context = "\n".join(context_docs)

    prompt = f"""
    Answer based on context only.

    Context:
    {context}

    Question: {query}
    """

    response = client.chat.completions.create(
        model=LLM_MODEL,
        messages=[{"role": "user", "content": prompt}]
    )

    return response.choices[0].message.content

🔁 Step 10: Full Pipeline
from app.pdf_processor import process_pdf
from app.embeddings import get_embeddings
from app.retriever import VectorStore
from app.reranker import rerank
from app.agent import RAGAgent
from app.chunking import chunk_text


def build_pipeline(pdf_path):
    text = process_pdf(pdf_path)
    chunks = chunk_text(text)

    embeddings = get_embeddings(chunks)

    store = VectorStore(len(embeddings[0]))
    store.add(embeddings, chunks)

    agent = RAGAgent(store, rerank)
    return agent

🚀 Step 11: FastAPI App
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
def query(q: str):
    docs = agent.run(q)
    answer = generate_answer(q, docs)
    return {"answer": answer}

🐳 Step 12: Dockerfile
FROM python:3.10

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

📘 README.md (Deployment Guide)
1. Clone Repo
    ```
        git clone <repo>
        cd rag-project
    ```

2. Setup Env
    ```
        python -m venv venv
        source venv/bin/activate   # Windows: venv\\Scripts\\activate
    ```

3. Install Dependencies
    ```
    pip install -r requirements.txt
    ```
4. Add .env
    OPENAI_API_KEY=your_key_here

5. Run Server
    ```
    uvicorn app.main:app --reload
    ```
6. API Usage
    Upload PDF
    ```
        POST /upload
    ```

    Query
    ```
        GET /query?q=your_question
    ```

🧠 Agentic Enhancements (Optional)
    Query rewriting
    Multi-hop reasoning
    Tool calling (search, DB, etc.)
    Feedback loop

⚡ Production Improvements
    Replace FAISS with Pinecone / Weaviate
    Add caching (Redis)
    Add async embedding calls
    Add streaming responses
    Add auth layer

✅ Done
    You now have a complete Agentic RAG pipeline with PDF + OCR + Re-ranking + FastAPI 🚀

We’ve created a complete, production-style Agentic RAG pipeline project for you in the canvas.
It includes:
    PDF processing (text + OCR for images)
    Chunking + embeddings
    FAISS vector store
    Re-ranking layer
    Agentic retrieval flow
    OpenAI-based answer generation
    FastAPI endpoints (/upload, /query)
    Docker setup
    Full README with deployment steps

You can now:
    Copy the project structure
    Follow the README step-by-step
    Run locally and test via API

---------------------------------------------------------
pdf2image internally runs a Poppler utility (pdfinfo) to read PDFs.
If Poppler is not installed or not in PATH → you get:
    PDFInfoNotInstalledError

✅ Fix (Windows – your case most likely)
1. Download Poppler
Go here:
👉 https://github.com/oschwartz10612/poppler-windows/releases/
Download latest zip (e.g. Release-xx.zip)

2. Extract

Extract to something like:

C:\poppler
3. Add to PATH

Add this path to environment variables:

C:\poppler\Library\bin

Steps:

Search: Environment Variables
Edit System PATH
Add above path
4. Restart terminal / VS Code
5. Verify installation

Run:

pdfinfo -v

If installed correctly → you’ll see version output

✅ Alternative (Quick Fix in Code)

If you don’t want to set PATH, modify your code:

from pdf2image import convert_from_path

images = convert_from_path(
    path,
    poppler_path=r"C:\poppler\Library\bin"
)

---------------------------------
TesseractNotFoundError
Means:

Tesseract is NOT installed
OR
Installed but not added to PATH

✅ Fix (Windows – step-by-step)
1. Install Tesseract

Download from:
👉 https://github.com/tesseract-ocr/tesseract

OR direct installer (recommended):
👉 https://github.com/UB-Mannheim/tesseract/wiki

Download:

tesseract-ocr-w64-setup.exe
2. Install with default path

Install to:

C:\Program Files\Tesseract-OCR

⚠️ During installation:
✔ Check “Add to PATH” (if available)

3. Verify installation

Open new terminal and run:

tesseract -v

You should see version output.

4. If still not working → manually set PATH

Add this to environment variables:

C:\Program Files\Tesseract-OCR

5. Quick Fix in Code (if PATH not set)
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

✅ Fix (Very Simple)
Step 1: Download eng.traineddata

Go here:
👉 https://github.com/tesseract-ocr/tessdata

Download this file:

eng.traineddata

Direct link:
👉 https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata

Step 2: Place it correctly

Put the file in:

C:\Program Files\Tesseract-OCR\tessdata
Step 3: Final folder should look like
C:\Program Files\Tesseract-OCR\
    ├── tesseract.exe
    ├── tessdata\
            ├── eng.traineddata   ✅ (this is required)
Step 4: Test again
tesseract --list-langs

Expected output:

eng

----------------------------