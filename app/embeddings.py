from openai import OpenAI
from app.config import EMBED_OPENAI_API_KEY, EMBED_MODEL

client = OpenAI(api_key=EMBED_OPENAI_API_KEY)


def get_embeddings(texts):
    response = client.embeddings.create(
        model=EMBED_MODEL,
        input=texts
    )
    return [e.embedding for e in response.data]