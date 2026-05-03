from openai import OpenAI

client = OpenAI(
    base_url="https://api.meshapi.ai/v1",
    api_key="your_api_key"
)

response = client.chat.completions.create(
    model="ai21/jamba-1-5-large-v1",
    messages=[
        {"role": "user", "content": "Hello"}
    ]
)

print(response.choices[0].message.content)