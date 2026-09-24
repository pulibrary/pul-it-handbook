# AI Code Generation Usage @ Princeton Library IT

Our departmental policies around AI usage for code generation are still forming.

However, as always we prioritize the following:

1. Diverse human expertise.
2. Thoughtful, focused engineering
3. Well understood and foundationally strong software products.
4. Respectful and helpful communication and collaboration.

To support those, we start with the following norms:

## Communication

The point of view and understanding of our human colleagues are the most important to us. When communicating through PRs, in chats, commit messages, or emails you should use your own language and reflection on your contribution. When debugging, if AI has supported you, take the time to understand what it's saying and what the trade-offs are so you can put them in your own words and reflect them. If you find that difficult, please reach out to a colleague to help you. We're a team.

No communication should be done purely by an agent, as a matter of respect for the readers. Avoid things like "Claude says we should" or pasting a response from an AI chat into a comment. If the message is too difficult or laborious to write, then please don't make others read it.

One of our greatest strengths is our community and respect for each other's time and attention.

## Attribution

Any contributions made via the use of AI should include the following in the pull request that results from it:

```
Assisted-by: AGENT_NAME:MODEL_VERSION
Assistance Level: [Investigative, Substantive, Complete, Other]
```

where the levels can be defined as:

**Investigative**: AI supported finding the root cause or helpful APIs, which were then independently understood, verified, and implemented.

**Substantive**: AI generated non-trivial portions of code, tests, or documentation.

**Complete**: From start to finish, an AI tool generated this solution, code, and documentation. Human intervention was largely in the form of prompts, if anything at all.

**Other**: Include some text describing the usage, if the above doesn't fit.

If multiple AI models were used simply repeat the Assisted-by line. If there was no agent, or you don't know the model, just do your best.

The goal is to see how our usage evolves over time and give reviewers a hint about where the code came from so they can adjust how they might do review and what assumptions they can make.

## Size of Code Contribution

Especially in the case when AI has generated code, err towards smaller chunks of code per pull request. Any PR that passes 200 lines of code is less likely to be thoroughly investigated, which can easily lead to loss of cohesive understanding of the system from all parties involved - both the submitter and the reviewer.
