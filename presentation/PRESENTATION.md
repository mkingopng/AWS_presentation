---
marp: true
theme: Night
paginate: true
---

# Introduction
**Topic**: Rust vs Python for AWS Lambda Functions

<!--
- I started learning Rust because i felt i would benefit from learning a low-level compiled langauge. 
- I know that Computer Science students are taught C and C++ and while most don't use it, the teaching staff appear to think its an important way to understand how software works. 
- I've been surprised at the range of applications for Rust and some of the claims being made. Its certainly a lot broader in applicability than i expected.
- This presentation compares the performance of Rust vs Python for lambda functions on AWS. 
- I use the K6 load test protocol as a basis for comparison. 
- I was inspired by 2 other presentations. The references for which are referenced at the end of the presentation.
-->

---

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
| Memory Management | No GC                           | GC                                |
| Performance       | Petaflop-level speed            | Slower in comparison              |
| Error Handling    | Strict compile-time checks      | Dynamic typing and runtime checks |
| Memory Safety     | Guaranteed memory safety        | Memory safety not guaranteed      |
| Ownership Model   | Unique & strict ownership model | No ownership model                |

<!--
Notes:
Compilation:
  - Rust: Compiled language that translates code into machine code before execution, resulting in high performance. Rust compilation is direct to machine code (unlike say Java). it doesn't require a JVM to run.
  - Python: Interpreted language that executes code line-by-line, which is slower than compiled languages.

Concurrency:
  - Rust: Supports concurrency with native features like async/await without being limited by a Global Interpreter Lock (GIL).
  - Python: Concurrency is limited by the GIL, which can prevent multiple 
native threads from executing Python bytecodes simultaneously. There are ways around this constraint, but they generally involve leveraging another language like C, C++ or Rust

Memory Management:
  - Rust: has no garbage collector. Instead it uses an ownership model that enforces rules at compile time to ensure safety. If your code generates garbage, it won't compile.
  - Python: Uses garbage collection to manage memory, which can simplify development but introduces overhead.

Performance:
  - Rust: Known for its speed and efficiency, capable of achieving petaflop-level performance in some cases.
  - Python: Generally slower due to its interpreted nature, but sufficient for many applications where development speed is prioritized.

Error Handling:
  - Rust: Enforces strict compile-time checks to catch errors early in the development process. No errors at run-time
  - Python: Uses dynamic typing and runtime checks, which can lead to errors being found later in the execution process.

Memory Safety
  - Rust: Guarantees memory safety by enforcing strict rules through its 
ownership model, preventing common bugs like null pointer dereferencing and buffer overflows.
  - Python: Memory safety is not guaranteed, and issues like buffer overflows are less common but still possible in certain scenarios.

Ownership Model:
  - Rust: Uses a unique ownership model to manage memory, ensuring safety and performance without needing a garbage collector.
  - Python: relies instead on garbage collection for memory management,  which is inefficient and creates the opportunity for errors
--> 

---

# Why is AWS investing in Rust?
- Memory Safety [Reference]()
- Performance [Reference]()
- resource efficiency & Cost [Reference]()
- Environment [Reference]()

---
# How is AWS using Rust?

AWS has already deployed a number of projects that use Rust, including 
  - Firecracker [Reference]()
  - Bottlerocket [Reference]()
  - AWS IoT Greengrass: [Reference]()
  - Amazon Prime: [Reference]()
  - Lambda Runtime: [Reference]()
  - AWS SDK for Rust: [Reference]()
  - the last 2 are what interest us today

<!--
- Memory Safety: The promise of replacing C, C++ and others in AWS services with a modern, memory safe language

- Environment: Rust is a "greener" language than Python. 

Broad adoption of Rust could reduce the energy consumption of compute by 50%

- AWS has already deployed a number of projects that use Rust, including 

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

I'd argue that it is a fair comparison in this context because Rust is being pitched by AWS as a potential replacement for Python in some cases, specifically for Lambda, as evidenced by the Rust Lambda Runtime and the Rust SDK.
-->

---

# The Rust Sales Pitch
Using Rust instead of Python (or TypeScript) to write your lambda functions will make them 
- faster [Reference]()
- more resource efficient [Reference]()
- cheaper [Reference]()
- more energy efficient [Reference]()

[Reference]()

---

# The Test

The choice of **K6** as a load testing method was pure "copy cat". I saw Illya Kavaliou's presentation earlier this year and thought it was a great idea. Why reinvent the wheel?

---
# The Code



---
# The Results

insert analysis of K6 tests here

---

# The Experience
I've found that 
- Rust is harder to learn and write than Python.
- Rust is significantly more verbose than Python.
- Rust throws a LOT more errors during development, 
- the frustration is eased somewhat by the excellent messages the compiler provides.
- the size of the Rust zip file is substantially smaller than the Python equivalent

---

# Conclusions
- Rust moves the cost to the development phase.
- Rust fixes old problems but introduces new ones too.

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

# Some issues worth noting:
- Rust is apparently very popular
- However there are not many Rust developers. This seems odd
- Rust has a really steep learning curve. 55% of Developers who start learning Rust give up due to the difficulty
- Rust is not as mature as Python

<!--
Experienced developers apparently take 6 months to become productive in Rust. I think that's optimistic. I'm at 6 months and i don't consider myself productive yet. The Rust 
  community

Rust doesn't have as many libraries and frameworks. The shortage of solutions to be found online used to be a problem but I think its improved a lot in the last 12 months.

LLMs have help IMMENSELY.

If you already have a working program in Python its a lot easier (IMHO) to then migrate to Rust. I've found its a lot  hard to to start with a blank file in Rust and build from scratch.
-->

---

# Why choose Rust over GO?
Overall, both languages are meant for many of the same purposes, and they both attempted to solve the same problem: In a C++ code base, you end up with 5+ year old code snippets everywhere that everyone's too afraid to touch in fear of breaking the entire program. Go sought to tackle this problem by making a language simple (even at the cost of removing practical abstractions) and easy to understand. Rust tackled this problem by retaining practical abstractions and ensuring the code's safe.

Go strives to distance itself from complexity -- code in Go is best seen as "composition from simple, easy to understand pieces," so that anyone approaching the code base has a chance to work on it.

The Rust philosophy is that you're willing to 
- sacrifice ease of use now, and argue with the compiler
- spend a more time researching your solution, if it means 
- in exchange you can write a code base that's still going strong five+ years from now.

---

# Conclusions
- I rather like Rust and plan to continue learning and building projects with it. 
- However I don't see it as a replacement for Python, rather perhaps as a compliment to it. I have this idea in my head: "Develop in Python, Deploy in Rust"
- My next task is to build a full ML pipeline in Rust, including serverless inference. I'm going to use Candle[]() and the Rust SDK for AWS. If people are interested, I'd love to sure to share my project with you.

---

# References
- [Rust Programming Language](https://www.rust-lang.org/)
- - **Lambda vs EC2 Comparison** by [Illya Kavaliou](https://github.com/ikavaliou-mg/lambda-ec2-ecs-comparison/tree/main)
- **Rustifying Serverless** by [Efi Merdler-Kravitz](https://www.youtube.com/watch?v=Mdh_2PXe9i8)
- 


---