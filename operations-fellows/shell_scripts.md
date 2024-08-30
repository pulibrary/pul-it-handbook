## Shell Scripts

The development of shell scripts, also known as shell scripting, consists in writing programs or scripts in a scripting language to automate tasks or perform operations on an Operating System.

### Bash Shell

The examples provided here use Bash(Bourne-Again Shell), often simply called `Bash`, is a command interpreter widely used in Linux systems. It offers a powerful way to interact with your operating system via an interface in the command line. It will be a useful exercise to make this cross platform.

### Installation of the Bash shell

The first step to working with the `Bash` is to ensure that it is installed on your system. In most Linux distributions, it is pre-installed. To check if `Bash` is already installed on your system, open a terminal and enter the following command:

```bash
bash --version
```

If you get an error then, like `command not found: bash` , it is necessary installing it:

```bash
sudo apt -y install bash
```

### Syntax and Bash script variables

To fully understand the development of Bash shell scripts, it is essential to mastering the basic syntax of language and understanding how to use variables which we will attempt to document here.
 
#### Syntax

Bash scripts are essentially text files containing a sequence. Bash Instructions. Here are some basic elements of the script syntax.

  * **Comments:** You can add comments in your scripts in using the character `#`. All that follows a `#` on a line is considered a comment and is ignored when executing the script.
    Example of a comment
    ```bash
     # this is a comment in a script
    ```
  * **Commands:** Bash commands are executed as text lines in the script. Each command is separated by a return to the line. By For example, to display text on the screen, you can use the command `echo - -`
    Example of a command
    ```bash
    echo "Hello World!"
    ```
  * **Separators:** The rarely used by the auther, semicolon (;) is used to separate several orders on a single line.
  * **Script structure:** A Bash script usually starts with a line referred to as "shebang" (`#!`) which indicates the path of the interpreter to be used to execute the script. For example, to use Bash, the first line of script is usually:
    ```bash
    #!/usr/bin/env bash
    ```

### Bash variables


Variables are essential for storing data in a Bash script. Here's how to report, assign and use variables in Bash.

Variable names are case-sensitive, which means that `foo` and `Foo` are different variables. I recommend that you use the names of variables in lower case to avoid confusion with variables system environment, which are generally capitalized.

#### Type variables, declare constants
