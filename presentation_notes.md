# AWS_presentation
Presentation to Brisbane AWS meetup group. Using the new AWS Rust SDK to perform experiments, collect data and compare the performance of lambda functions written in Rust vs Python

# Title: **Improve performance and reduce cost of AWS Lambda: Python vs. Rust**

## Introduction
1. **Welcome and Introduction**
   - Briefly introduce yourself and your background.
   - Mention the purpose of the presentation and why this comparison is relevant.

2. **Overview of AWS Lambda**
   - Quick introduction to AWS Lambda and its use cases.
   - Highlight the common programming languages used (Python, TypeScript, etc.).

## Why Compare Python and Rust for AWS Lambda?
1. **The Popularity of Python**
   - Discuss why Python is widely used for AWS Lambdas (ease of use, large ecosystem, etc.).
   - I'm going to assume that the audience is familiar with Python
   
2. **Introduction to Rust and the AWS Rust SDK**
   - Briefly introduce Rust as a language.
   - Why as AWS invested in Rust?
   - Discuss the new AWS Rust SDK and its potential benefits.

## Performance Comparison
1. **Setting Up the Test Environment**
   - Explain the test environment and setup.
   - Mention the load testing tool you will use (e.g., k6).

2. **Performance Metrics**
   - Define the metrics you will use to measure performance (e.g., 
	 execution time, memory usage, cold start time, etc.).

3. **Running the Tests**
   - Show the process of running load tests on both Python and Rust Lambdas.
   - Include some code snippets or configurations used for the tests.

4. **Results and Analysis**
   - Present the results in a clear and organized manner (graphs, charts, etc.).
   - Compare the performance metrics for Python and Rust.
   - Discuss the cost implications based on the performance results.

5. **Notes of Rust idiosyncrasies**

## Benefits and Trade-offs
1. **Benefits of Using Rust**
   - Highlight the significant reduction in cost and increase in 
	 performance, resulting from using Rust instead of Python
   - AWS has been a founding member of the Rust Foundation and is investing 
	 heavily in Rust as a language for cloud-native development. I think 
	 AWS regards Rust as a language of the future for some applications.
   - Discuss other potential benefits (e.g., better control over memory, safety features, etc.).

2. **Challenges and Trade-offs**
   - Address the learning curve associated with Rust. Rust has a steep 
	 learning curve, and optimistically it will take an already experienced 
	 developer 6 months to be productive in Rust.
   - There are not as many Rust developers. The pool is much smaller 
	 than the pool of pyton developers.
   - Development time: Rust really moves the cost to development of the 
	 code, rather than its execution. Things simply take longer to develop in Rust. 
   - Discuss the ecosystem and community support for Rust vs. Python.

## Conclusion
1. **Summary of Findings**
   - Recap the key points and findings from your comparison.

2. **Recommendations**
   - Provide recommendations based on your results (e.g., when to use Python vs. Rust).
   - Develop in Python, deploy in Rust
   - migrate to Rust one step at a time by using PYO3 and Maturin. migrate 
	 your functions and methods that are the most expensive, then import 
	 them into your Python code as a library

3. **Q&A**
   - Open the floor for questions and discussions.

### Additional Tips
- **Live Demo:** If possible, consider doing a live demo of deploying and 
  testing a simple Lambda function in both Python and Rust.
- **Engage the Audience:** Ask questions or include small interactive 
  segments to keep the audience engaged.
- **Resources:** Provide links to your source code, test scripts, and any 
  other resources for the audience to explore further.

## Other Benefits that Rust offers
Using Rust for AWS Lambda functions offers several additional benefits beyond reduced memory footprint, faster speed, and lower cost. Here are some other notable advantages:

### Additional Benefits of Using Rust

1. **Safety and Reliability**
   - **Memory Safety:** Rust’s ownership system ensures memory safety without needing a garbage collector, reducing the chances of memory leaks and other related bugs.
   - **Concurrency Safety:** Rust's concurrency model allows you to write safe and concurrent code, reducing the risks associated with multithreaded applications.

2. **Performance**
   - **Predictable Performance:** Rust provides predictable performance due to the absence of a garbage collector and the ability to write low-level code that is optimized for performance.
   - **Compile-time Guarantees:** Rust’s powerful type system and compile-time checks catch many errors early, leading to more reliable and optimized code.

3. **Modern Tooling and Ecosystem**
   - **Cargo:** Rust’s package manager and build system, Cargo, simplifies project management, dependency management, and building processes.
   - **Crate Ecosystem:** The growing ecosystem of crates (libraries) in Rust provides robust and reusable components for a variety of tasks, from web development to cryptography.

4. **Cross-Platform Capabilities**
   - **Wasm Support:** Rust can compile to WebAssembly (Wasm), allowing you to write code that runs in the browser or other Wasm-supported environments, offering a seamless integration between server-side and client-side logic.
   - **Portability:** Rust’s cross-platform support makes it easy to target multiple environments, including AWS Lambda, embedded systems, and desktop applications.

5. **Developer Productivity**
   - **Error Handling:** Rust’s powerful error handling mechanisms (Result and Option types) make it easier to write robust and error-resistant code.
   - **Documentation and Community:** Rust has excellent documentation and a supportive community that can help developers learn and adopt the language efficiently.

6. **Security**
   - **Security Focus:** Rust’s design focuses on security, helping to prevent common security vulnerabilities like buffer overflows, null pointer dereferencing, and data races.
   - **Auditable Code:** Rust’s clear and concise syntax, combined with its safety guarantees, makes it easier to audit code for security vulnerabilities.

7. **Long-term Maintainability**
   - **Stability:** Rust’s strict compiler checks and stable language features lead to more maintainable codebases, as many issues are caught at compile time rather than runtime.
   - **Ecosystem Maturity:** As the Rust ecosystem matures, more libraries and tools are becoming available, making it easier to maintain and extend Rust-based projects.

### Conclusion
While the primary draws of Rust for AWS Lambda are its performance, memory efficiency, and cost-effectiveness, the language offers a holistic set of benefits that contribute to safer, more reliable, and maintainable code. These advantages make Rust an attractive choice for developers looking to build high-performance, scalable, and secure serverless applications.

# points
- the first clue that we're dealing with different beasts is the code itself. 
- Rust is significantly more verbose, and the syntax is more complex. 
- I find it more difficult to read than the equivalent python code
- the next is the size of the zip file.
- we can see that the lambda.zip file in Rust is 3.5mb. The python zip file on the other hand is 70mb
- we can't deploy the python lambda simply by uploading the zip file in the AWS console. we need to use docker or another solution.
- This additional size and complexity should immediately tip us off as to whats coming
- 

### questions
be ready to answer Level 4 type questions, eg 
- why not choose Go? it makes a lot of similar claims to Rust
- please explain the syntax of the code you've presented

### references