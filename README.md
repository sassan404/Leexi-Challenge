# Project Overview

This project is a Ruby-based web application using the Sinatra framework. It includes several controllers and classes to
manage pricing modules, subscriptions, and basic responses.

## Classes and Modules

### `HelloWorldController`

This controller handles a simple GET request to return a "Hello, World!" message in JSON format.

### `PricingModulesController`

This controller handles GET requests to return a list of pricing modules in JSON format.

### `SubscriptionController`

This controller handles POST requests to create a subscription and compute prices based on the provided data.

### `PricingModule`

This class represents a pricing module with attributes for plan, number of licenses, and price per license. It includes
validation methods and a method to convert the object to JSON.

### `Prices`

This class represents the prices for a subscription, with attributes for monthly and annual prices. It includes
validation methods and a method to convert the object to JSON.

### `Subscription`

This class represents a subscription with attributes for plan, number of licenses, and period. It includes methods to
validate the input, find the appropriate pricing module, and compute prices.

## Schematic Overview

```plaintext
+------------------------+       +------------------------+
|   HelloWorldController |       | PricingModulesController|
|------------------------|       |------------------------|
| + get_message          |       | + /v1/prices            |
+------------------------+       +------------------------+
            |                                |
            v                                v
+------------------------+       +------------------------+
|  SubscriptionController|       |    PricingModule       |
|------------------------|       |------------------------|
| + /v1/prices           |       | + initialize           |
| + create_from_json     |       | + to_json              |
| + compute_prices       |       +------------------------+
+------------------------+                |
                                           |
                                           v
                                  +------------------------+
                                  |        Prices          |
                                  |------------------------|
                                  | + initialize           |
                                  | + to_json              |
                                  +------------------------+
```

## Setup and Running the App

### Prerequisites

- Ruby (version 3.0 or higher)
- Bundler

### Installation

1. Clone the repository:
   ```sh
   git clone <repository_url>
   cd <repository_directory>
   ```

2. Install dependencies:
   ```sh
   bundle install
   ```

### Running the App

To run the application, execute the following command:

```sh
ruby app.rb
```

### Running Tests

To run the tests, use the following command:

```sh
ruby -I test test/app_test.rb
```

This command sets up the test environment and runs the specified test file.