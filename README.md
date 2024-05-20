# Gissues

Gissues is a CLI application that fetches and displays issues from a specified GitHub repository in a markdown table format.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Development](#development)

## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/your_username/gissues.git
   ```

2. Navigate to the project directory:

   ```sh
   cd gissues
   ```

3. Install dependencies:

   ```sh
   mix deps.get
   ```

4. Compile the project:

   ```sh
   mix compile
   ```

## Configuration

Configure the GitHub API base URL and HTTP client in `config/config.exs`:

```elixir
config :gissues, :github_url, "https://api.github.com/"
config :gissues, :http_adapter, HTTPoison
config :gissues, :provider, Gissues.Providers.Github
```

## Usage

To run the CLI application, use the following command:

```sh
mix run -e 'Gissues.CLI.main(["user", "project", "count"])'
```

Replace `user`, `project`, and `count` with the appropriate values:

- `user`: The GitHub username.
- `project`: The GitHub repository name.
- `count`: (Optional) The number of issues to display. Defaults to 4 if not specified.

Example:

```sh
mix run -e 'Gissues.CLI.main(["elixir-lang", "elixir", "5"])'
```

### Help

To display the help message, use:

```sh
mix run -e 'Gissues.CLI.main(["--help"])'
```

or

```sh
mix run -e 'Gissues.CLI.main(["-h"])'
```

## Development

### Testing

1. Install test dependencies:

   ```sh
   mix deps.get --only test
   ```

2. Run the tests:

   ```sh
   mix test
   ```

### Mocking with Mox

Ensure the setup and configurations for mocks are correctly implemented in `test_helper.exs`:

```elixir
Mox.defmock(Gissues.MockHTTPoison, for: HTTPoison.Base)
Application.put_env(:gissues, :http_adapter, Gissues.MockHTTPoison)
```

### Formatting

To format the code, run:

```sh
mix format
```

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```

```

```

```
