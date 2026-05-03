# 🧾 Project Title

## 📚 Agentic RAG Pipeline with FastAPI (PDF + OCR + Re-ranking)


# 🚀 One-liner Description

A production-ready Retrieval-Augmented Generation (RAG) system that ingests PDFs (including scanned images), performs intelligent retrieval with re-ranking, and answers user queries using OpenAI models via FastAPI.

---

# ❗ Problem Statement

Organizations often deal with large volumes of unstructured PDF documents containing both text and images (scanned documents). Extracting meaningful insights manually is time-consuming and inefficient.

This project solves:

* Querying large PDFs using natural language
* Extracting information from scanned documents (OCR)
* Improving retrieval accuracy using re-ranking
* Providing fast API-based access for integration

---

# 🧠 Architecture Diagram (RAG Flow)

```
                ┌──────────────┐
                │   PDF Input  │
                └──────┬───────┘
                       │
        ┌──────────────▼──────────────┐
        │ PDF Processing (Text + OCR) │
        └──────────────┬──────────────┘
                       │
               ┌───────▼────────┐
               │   Chunking     │
               └───────┬────────┘
                       │
               ┌───────▼────────┐
               │ Embeddings API │
               └───────┬────────┘
                       │
               ┌───────▼────────┐
               │ Vector Store   │ (FAISS)
               └───────┬────────┘
                       │
        ┌──────────────▼──────────────┐
        │ Retriever (Top-K Results)   │
        └──────────────┬──────────────┘
                       │
               ┌───────▼────────┐
               │ Re-Ranker      │
               └───────┬────────┘
                       │
               ┌───────▼────────┐
               │ Agent Layer    │
               └───────┬────────┘
                       │
               ┌───────▼────────┐
               │ OpenAI LLM     │
               └───────┬────────┘
                       │
               ┌───────▼────────┐
               │ Final Answer   │
               └────────────────┘
```

---

# 📁 Project Structure
```
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
```

---

# 🧰 Tech Stack

### Backend

* FastAPI
* Python

### AI / ML

* OpenAI (Embeddings + LLM)
* FAISS (Vector DB)
* Scikit-learn (Re-ranking)

### Document Processing

* PyPDF (text extraction)
* pdf2image (PDF → images)
* pytesseract (OCR)

### Infra / Tools

* Docker (optional)
* Uvicorn (ASGI server)

---

# ⚙️ Setup & Installation Instructions

## 1. Clone Repository

```bash
git clone <your-repo-url>
cd rag-project
```

## 2. Create Virtual Environment

```bash
python -m venv venv
```

### Activate

```bash
# Windows
venv\Scripts\activate

# Linux / Mac
source venv/bin/activate
```

---

## 3. Install Dependencies

```bash
pip install -r requirements.txt
```

---

## 4. Setup Environment Variables

Create `.env` file:

```env
OPENAI_API_KEY=your_openai_api_key
```

---

## 5. Install System Dependencies (IMPORTANT)

### ✅ Poppler (for PDF images)

* Download: [https://github.com/oschwartz10612/poppler-windows/releases/](https://github.com/oschwartz10612/poppler-windows/releases/)
* Add to PATH:

```
C:\poppler\Library\bin
```

---

### ✅ Tesseract OCR

* Download: [https://github.com/UB-Mannheim/tesseract/wiki](https://github.com/UB-Mannheim/tesseract/wiki)
* Install to:

```
C:\Program Files\Tesseract-OCR
```

Add to PATH:

```
C:\Program Files\Tesseract-OCR
```

---

### ✅ Add Language Data

Ensure this file exists:

```
C:\Program Files\Tesseract-OCR\tessdata\eng.traineddata
```

If missing, download from:
[https://github.com/tesseract-ocr/tessdata](https://github.com/tesseract-ocr/tessdata)

---

### ✅ Optional (Recommended in Code)

```python
import pytesseract
import os

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
os.environ["TESSDATA_PREFIX"] = r"C:\Program Files\Tesseract-OCR\tessdata"
```

---

# ▶️ How to Run Locally

## Start FastAPI Server

```bash
uvicorn app.main:app --reload
```

Server will run at:

```
http://127.0.0.1:8000
```

---

## 🏠 Home

Endpoint:

```
GET /Home
```

Example:

```bash
curl -X 'GET' \
  'http://127.0.0.1:8000/' \
  -H 'accept: application/json'
```

---

## 📤 Upload PDF

Endpoint:

```
POST /upload
```

Example:

```bash
curl -X 'POST' \
  'http://127.0.0.1:8000/upload' \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -F 'file=@sample-compressed.pdf;type=application/pdf'
```

---

## ❓ Query PDF

Endpoint:

```
GET /query?query=your_question
```

Example:

```bash
curl -X 'GET' \
  'http://127.0.0.1:8000/query?query=what tasks can discuss in experiments details?' \
  -H 'accept: application/json'
```

---

# ✅ Output

* Extracts text from PDF
* Extracts text from images (OCR)
* Retrieves relevant chunks
* Re-ranks results
* Generates accurate answer using LLM

---

# 🚀 Future Enhancements

* Multi-document support
* Hybrid search (BM25 + Vector)
* Streaming responses
* UI (React / Streamlit)
* Replace OCR with Vision models

---

# 🎯 Conclusion

This project provides a complete end-to-end implementation of an **Agentic RAG pipeline** capable of handling real-world PDFs with both text and images, making it suitable for enterprise document intelligence use cases.
