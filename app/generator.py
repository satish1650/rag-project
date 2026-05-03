from openai import OpenAI
from app.config import BASE_URL, OPENAI_API_KEY, LLM_MODEL

client = OpenAI(base_url=BASE_URL, api_key=OPENAI_API_KEY)


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