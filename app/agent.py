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