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

Unlike most programming languages, Bash does not have variable. In order to make references to variable one has to use internal commands  to declare a typed variable using `declare` or `typeset` (they are synonyms)

```bash
declare [OPTION] name=value
```

The main options:

  * `-r`: Create a read-only variable
  * `-i`: An Integer
  * `-a`: A table
  * `-f`: A function
  * `-x`: Declares the availability of a variable for export outside the environmental of the script itself.

Example:
  ```bash
lldeclare -i x=21*2
```

#### Declaring of variables

You can declare a variable using the equal sign (`=`) without spaces around the sign, followed by the name of the variable.

**Example of variable declaration:**

```bash
name="Foo"
number=42
```

#### Use of variables

You can access the values stored in a variable by placing the name of the variable preceded by the character `$` and using the function `echo`.

**Example of the use of variables:**

```bash
echo "My name is $name and my favorite number is $number"
```

### Environmental variables

Environment variables are system variables used by the operating system and applications for storing information important in the current working environment of the system. They are used for the overall behaviour of the system, programs and processes. Environmental variables may contain information, such as search paths, configuration parameters, location information, identification information, etc.

The environment variables are available for all processes and applications currently being executed on the system.

You can define, modify and delete environment variables by using specific commands in the Shell. For example, in Bash, you can use the export command to define a variable of the environment.

```bash
#!/usr/bin/env bash

# Access a new USER variable
export MY_VARIABLE=bar

echo "This user's variable is $MY_VARIABLE."
```

In order to distinguish between environment variables and other variables, they are met in capital letters.

#### Current environment variables

There are many commonly used environmental variables. Here's some commonly used examples:
  * PATH: Contains a directory list where the system searches for command executables.
  * HOME: The user's personal directory.
  * USER: The name of the current user.
  * LANG: Language and location configuration.
  * SHELL: The user's Shell path by default.
  * PWD: The current directory


