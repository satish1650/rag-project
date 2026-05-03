import os
from dotenv import load_dotenv

load_dotenv()

BASE_URL="https://api.meshapi.ai/v1"
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
EMBED_OPENAI_API_KEY = os.getenv("EMBED_OPENAI_API_KEY")
EMBED_MODEL = "text-embedding-3-small"
LLM_MODEL = "openai/gpt-4o-mini"
VECTOR_PATH = "vectorstore/index.faiss"