# Tool Primer (Plain English)

No prior AWS or coding experience needed — this is here so nobody hits a term cold mid-build.

| Term | What it actually is |
| --- | --- |
| AWS | Amazon's cloud platform — rents you computing power and services instead of running your own servers |
| S3 | Simple online storage — can host a static webpage |
| Lambda | A small piece of code that runs only when needed — the "glue" between the frontend and the AI |
| API Gateway | The "front door" that receives a request from the frontend and hands it to Lambda |
| Bedrock | Amazon's service for calling AI models (like Claude) without running your own AI infrastructure |
| Kiro | An AI coding assistant — you describe what you want in plain English, it writes and deploys the code |

## Tips for writing a good spec for Kiro

- Say what it should do, for whom, and with what data — not how to code it ("a web page where you paste a customer ticket and get back a category and a drafted reply, using Bedrock" beats a technical description)
- Be specific about inputs and outputs (what goes in, what should come back)
- If something doesn't work, describe what you see and what you expected — Kiro can iterate from that
- Small steps beat one giant spec: get something working end-to-end first (even calling Bedrock locally), then deploy it, then improve it one step at a time
