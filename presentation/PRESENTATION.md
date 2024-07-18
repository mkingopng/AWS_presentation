---
marp: true
theme: Night
paginate: true
backgroundSize: contain
---

# Introduction
**Topic**: Rust vs Python for AWS Lambda Functions

<!--
- I started learning Rust because i felt i would benefit from learning a low-level compiled langauge. 
- I know that Computer Science students are taught C and C++ and while most don't use it, the teaching staff appear to think its an important way to understand how software works. 
- I've been surprised at the range of applications for Rust and some of the claims being made. 
- Its certainly a lot broader in applicability than i expected. Lambda functions are an example
- This presentation compares the performance of Rust vs Python for lambda functions on AWS.
-->

---

Rust focuses on safety and performance. It doesn't pretend to make things easy.

# Rust History
- **2006**: created by Graydon Hoare
- **2009**: Mozilla became involved
- **2010**: official public announcement
- **2015**: v1.0 released
- **2020**: AWS joined to Rust foundation
- **2023**: AWS announced Rust SDK for AWS

---

# Rust Features (in comparison to Python)

| Feature           | Rust                            | Python                            |
|-------------------|---------------------------------|-----------------------------------|
| Compilation       | Compiled                        | Interpreted                       |
| Concurrency       | Native concurrency support      | GIL                               |
| Memory Management | No Garbage Collector            | Garbage Collector                 |
| Performance       | Petaflop-level speed            | Slower in comparison              |
| Error Handling    | Strict compile-time checks      | Dynamic typing and runtime checks |
| Memory Safety     | Guaranteed memory safety        | Memory safety not guaranteed      |
| Ownership Model   | Unique & strict ownership model | No ownership model                |

<!--
Notes:
Compilation:
  - Rust is a compiled language that translates code into machine code before execution.
  - Rust compilation is direct to machine code 
  - Unlike Java, another compiled language, Rust doesn't require a JVM to run.
  - Python, an interpreted language executes code step-by-step.
  - No pre-runtime translation takes place. Errors show up at runtime
  - because of this, Python is slower than compiled languages.

Concurrency:
  - Rust: Supports concurrency with native features like async/await without being limited by a Global Interpreter Lock (GIL).
  - Python: Concurrency is limited by the GIL, which can prevent multiple native threads from executing Python bytecodes simultaneously. 
  - There are ways around this constraint, but they involve leveraging another language like C, C++, CUDA or Rust
--> 

---

# visualising the difference between compiled and interpreted languages

![Compiled vs Interpreted](./../data/lambda_screenshot.png)

---

# Why is AWS investing in Rust?
- Memory Safety
- Performance
- Resource efficiency & cost
- Environment

<!--
- Memory Safety: Approx 70% of security vulnerabilities relate to memory 
management issues. The promise of replacing C, C++ etc with a modern, 
memory safe language alternative in AWS services is obviousy a big draw

- Environment: Rust is a "greener" language than Python. 

Broad adoption of Rust could reduce the energy consumption of compute by 50%
-->

---
# How is AWS using Rust?

AWS has already deployed a number of projects that use Rust, including 
  - Firecracker
  - Bottlerocket
  - AWS IoT Greengrass
  - Amazon Prime
  - Lambda Runtime
  - AWS SDK for Rust
  - the last 2 are what interest us today

<!--
AWS has already deployed a number of projects that use Rust, including
  - Firecracker, a virtualization technology that powers AWS Lambda and Fargate
  - Bottlerocket, a Linux-based operating system that runs containers is partly written in Rust
  - AWS IoT Greengrass: a software that extends AWS cloud capabilities to local devices
  - Amazon Prime:
  - Lambda Runtime: AWS has developed Rust runtime support for AWS Lambda, enabling developers to write serverless functions in Rust. This leverages Rust’s performance and safety, making serverless applications faster and more reliable
  - AWS SDK for Rust: AWS has released an official SDK for Rust, enabling developers to build Rust applications that interact with AWS services.
  - the last 2 are what interest us today
-->

---

# Apples & Oranges?

Given the differences between the two languages, is this a fair comparison?

<!--
It's legitimate to ask if this is a fair comparison because Rust is pitched as a compiled systems-level programming language, while Python is an interpreted, general-purpose language. They are obviously two different animals

I'd argue that it is a fair comparison in this context because Rust is 
being pitched by AWS as a potential replacement for Python in some cases, 
specifically for Lambda, as evidenced by the Rust SDK, and the promotion 
around it.
-->

---

# The Rust Sales Pitch

Using Rust instead of Python (or TypeScript) to write your lambda functions will make them 
- faster
- more resource efficient
- cheaper
- "Green", ie much more energy efficient

Sounds too good to be true? Thats kinda true. There are a number of caveats 
that are important and seldom mentioned we'll talk about these at the end 
of the presentation

---

# The Test

I've written two lambda functions, one in Rust, one in Python. They do the same thing
- generate a UUID
- save it as a .txt file in an S3 bucket
- enter it as a record into a DynamoDB table
- we use K6 to test the performance of the two functions under a range of 
  conditions

Its intended to be a simple example that we can replicate easily

[K6](https://k6.io/) is a free performance testing tool

---
# The Code

- look at the script for the Rust lambda function
- compare with the Python script
- demonstrate how to compile the Rust code
- demonstrate errors in Rust

<!--
always use `--strip` and `--release` when building your Rust code for deployment. 
This will strip out all unnecessary information and make the binary smaller and faster.
Don't use debug unless you're debugging. It makes the bigger and slower

note that AWS SAM normally caches artifacts when you're building your lambda
However AWS Sam won't cache the changes when you're building your rust code 
-->

---
# The Results: Cost

**Confession**: I could not achieve the 8 - 10x improvement that others have 
written about. I beleive it's because my Rust code is not as optimised as it 
could be. Lets call it an opportunity for improvement

However, I did achieve 3-4x improvement in cost. This is still significant

let's look at costs first, because for most of you i expect that's the most interesting

---

### Cost comparison

![Cost Comparison](./../data/cost_comparison_2.png)

---

| Language | Time | Cost          | Comparison                       |
|----------|------|---------------|----------------------------------|
| Rust     | 5ms  | $0.0000000105 |                                  |
| Python   | 23ms | $0.0000000210 | 360% slower. 357% more expensive |

For 100m lambda invocations:
- Rust: $1.05
- Python: $4.80

---
### Results: latency

![Latency COmparison](./../data/latency_comparison.png)

<!--
Personally, I find this the most exciting part. You can see that there is absolutely no change in the latency regardless of the amount of memory allocated
-->

---
# Cold Start Comparison

![Cold Start Comparison](./../data/cold_start_comparison.png)

<!--
I was surprised to see that in this case I did achieve the kind of performance differential that I'd expected
-->

---

# The Experience
I think that the developer experience is important to mention. I've found that
- Rust is harder to learn and write than Python.
- Rust is significantly more verbose than Python.
- Rust throws a LOT more errors during development, 
- the frustration is eased somewhat by the excellent messages the compiler provides.
- the size of the Rust zip file is substantially smaller than the Python equivalent
- Rust is apparently very popular, but there are not many Rust developers. This seems odd.
- Rust is not as mature as Python

<!--
Experienced developers apparently take 6 months to become productive in Rust. I think that's optimistic. I'm at 6 months and i don't consider myself productive yet. The Rust 
  community

Rust doesn't have as many libraries and frameworks. The shortage of solutions to be found online used to be a problem but I think its improved a lot in the last 12 months.

LLMs have help IMMENSELY.

I've found its a lot  hard to to start with a blank file in Rust and build from scratch. If you already have a working program in Python its a lot easier (IMHO) to then migrate to Rust. 
-->

---

# Conclusions
- Rust delivers a massive improvement in performance, along with the other 
  oft touted benefits
- Rust moves the cost to the development phase.
- Rust fixes old problems but introduces new ones too, specifically, at the development stage
- Rust trades costs on AWS for increased development costs
- There is a compromise solution which we'll come to

---

# Why and when to use Python
- You can build things quickly in Python, so its the obvious choice When you're building prototypes
- Python is ubiquitous in data engineering, data science and machine learning. You'll have no problems finding developers who can work with it.
- For things that need to be read, understood and maintained by many developers, Python is the obvious choice.
- Everything has Python SDKs and APIs

---

# Why and when to use Rust
- You can build the best tooling with Rust. It just takes more time.
- When you need maximum performance, stability and memory safety, you should consider Rust for your application. Its a clear alternative to C++ and C.
- Suitable for applications requiring high concurrency and memory safety. Faster than languages like Go.
- Ideal for infrastructure and systems programming.

---

# A Compromise solution
- Its not necessary to re-write your entire code base
- You can write performance-critical components in Rust, while keeping the rest of your codebase in Python.
- 50-70% of the benefits

<!--
when you have a large existing Python Codebase, its not appealing to move to Rust. That would be a massive undertaking, and is not necessary

Rust crates like Py03 and Maturin allow you to write Rust code, 
compile it, then call it from Python as you would any other library.

This is what Polars have done. 

HuggingFace have taken a similar approach with their Rust-based "fast tokenizers".

This approach makes it possible to write performance-critical components inRust, while keeping the rest of your codebase in Python.

- This substantially reduces the cost and complexity of the task and delivers approximately 50-70% of the performance lift full Rust migration.

-->

---

# Why choose Rust over GO?
Overall, both languages are meant for many of the same purposes, and they both 
attempted to solve the same problem: In a C++ code base, you end up with 5+ 
year old code snippets everywhere that everyone's too afraid to touch in fear 
of breaking the entire program.

Go strives to distance itself from complexity -- code in Go is best seen as "composition from simple, easy to understand pieces," so that anyone approaching the code base has a chance to work on it.

The Rust philosophy is that you're willing to 
- sacrifice ease of use now, and argue with the compiler
- spend a more time researching your solution, if it means 
- in exchange you can write a code base that's still going strong five+ years from now.

---

# Conclusions
- I like Rust and plan to continue learning and building projects with it. 
- However I don't see it as a replacement for Python, rather perhaps as a compliment to it. I have this idea in my head: "Develop in Python, Deploy in Rust"
- My next task is to build a full ML pipeline in Rust, including serverless inference. I'm going to use [Candle](https://github.com/huggingface/candle) and the Rust SDK for AWS. If people are interested, I'd love to sure to share my project with you.

---

# Acknowledgements
- a big thank you to Alan Blockley for coaching me in preparation for this presentation
- Also a big thank you to Illya Kavaliou from mantel Group. He runs the 
  serverless group and his recent presentation was an inspiration for this 
  experiment.

---

# References
- **Rust Home** [Rust Programming Language](https://www.rust-lang.org/)
- **Lambda vs EC2 Comparison** by [Illya Kavaliou](https://github.com/ikavaliou-mg/lambda-ec2-ecs-comparison/tree/main)
- **Rustifying Serverless** by [Efi Merdler-Kravitz](https://www.youtube.com/watch?v=Mdh_2PXe9i8)
- **Sustainability with Rust** [AWS Blog](https://aws.amazon.com/blogs/opensource/sustainability-with-rust/)
- **Why AWS is the Best Place to Run Rust** [AWS Blog](https://aws.amazon.com/blogs/devops/why-aws-is-the-best-place-to-run-rust/)
---

# GitHub repo

AWS Presentation https://github.com/mkingopng/AWS_presentation)

Please feel free to contact me on [LinkedIn](https://www.linkedin.com/feed/) or 
GitHub if you have any questions or would like to collaborate on a project
