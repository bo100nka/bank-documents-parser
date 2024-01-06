# bank-documents-parser

## About
This solution automates scanning of digital bank statement documents from various banks and exporting the payments received records into a structured, configurable CSV file format.

It was developed as a windows console application using .NET 8 framework.

The source code is maintained here

## References
* source code - https://github.com/bo100nka/bank-documents-parser
* .NET 8 runtime installers - https://dotnet.microsoft.com/en-us/download/dotnet/8.0

## Installation

### Prerequisites

* .NET 8 runtime installed (see References)

### Application

Package can be obtained either by:
* manually building the solution from source _(requires C# .NET development expertise)_ or by
* manually downloading pre-built binary package and extracting it into a desired work directory _(link for download sent via email)_

## Usage

### Test run mode ON
* Run the application by executing the `bank-statements-parser.exe` binary application file _(you can also create a shortcut to it)_
    * This will initialize the system and create a default work directory structure and a config file located at `c:/YellowNET` and then simply exit.
* Locate the config file `appsettings.json` and open it in `notepad`
* Disable `TestRunMode` setting _(change its value from `true` to `false`)_ - this will disable the "First time run" behavior.
* Optionally change any setting
* Save the file

### Test run mode OFF
When the application is executed with the `TestRunMode` setting off, it will start the main process workflow:
* locates all bank statement documents in the configured directories, for example:
    * `c:/YellowNET/TatraBanka`
    * `c:/YellowNET/SlovenskaPosta`
    * _(WIP)_ `c:/YellowNET/VUB`
* parses each document in the defined folders
* converts each document into a `csv` version in `c:/YellowNET/Output`
* additionally creates a `merged csv` version for easier import and/or analysis

## Logging
The application logs every step it performs into:
* the console standard output
* a log file located at `c:/YellowNET/app.log` _(which can be viewed by `notepad`)_.

## Remarks
* The application flow ignores any `outgoing` payments.
