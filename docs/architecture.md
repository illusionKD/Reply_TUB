# Suggested Architecture

## Target flow

```text
Frontend
   |
   v
Backend API
   |
   v
Amazon Bedrock
   |
   v
Response draft
```

## Possible AWS implementation

```text
Frontend
   |
   v
API Gateway
   |
   v
AWS Lambda
   |
   v
Amazon Bedrock
```

## Implementation guidance

Start with the simplest architecture that can produce a working result.

**AWS deployment is required, not optional.** The final demo must call a deployed API Gateway endpoint backed by a Lambda function invoking Bedrock — not a process running only on localhost.

The team may still:
- Build and test locally first while iterating quickly.
- Use a local backend temporarily during development.

But before the demo, the same flow must be redeployed behind API Gateway + Lambda, and the demo must use that live endpoint.

## Design principles

- Keep responsibilities separated.
- Do not expose AWS credentials in frontend code.
- Validate user input.
- Return useful errors.
- Keep the Bedrock model ID configurable.
- Avoid hardcoding secrets.
