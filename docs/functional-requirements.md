# Functional Requirements

## Minimum viable product

### FR-01: Ticket input

The user can enter or paste a customer support ticket.

### FR-02: Category

The user can select a ticket category or enter a category manually.

Automatic classification is optional.

### FR-03: Generate draft

The user can trigger generation of a response draft using Amazon Bedrock.

### FR-04: Display result

The application displays the generated response in a readable format.

### FR-05: Human review

The application displays:

> AI-generated draft. Human review required before sending.

### FR-06: Validation

The application prevents generation when the ticket is empty and displays a helpful validation message.

### FR-07: Loading state

The application shows that generation is in progress.

### FR-08: Error handling

The application displays a useful error message if the backend or model invocation fails. Do not expose credentials or internal secrets.

## Backend expectations

The backend should:
- Receive the ticket and category.
- Validate the request.
- Build a prompt using the business context and behavior guidelines.
- Invoke Amazon Bedrock.
- Return a structured response to the frontend.

**Deployment requirement**: the backend must run on AWS (API Gateway + Lambda) for the final demo, not only on localhost. Local runs are fine during development.

## Out of scope

- Sending emails.
- Real customer accounts.
- Real order lookups.
- Automatic refunds.
- Production-grade authentication.
- Complex analytics.
