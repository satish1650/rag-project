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