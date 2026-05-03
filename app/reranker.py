from sklearn.metrics.pairwise import cosine_similarity


def rerank(query_emb, docs, doc_embs):
    scores = cosine_similarity([query_emb], doc_embs)[0]
    ranked = sorted(zip(docs, scores), key=lambda x: x[1], reverse=True)
    return [doc for doc, _ in ranked]