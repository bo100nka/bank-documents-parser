# bank-documents-parser

## About
This solution automates scanning of digital bank statement documents from various banks and exporting the payments received records into a structure CSV file format.

It was developed as a windows console application using .NET 8 framework.

The source code is maintained here: https://github.com/bo100nka/bank-documents-parser

## Installation
Package can be obtained either by:
- manually building the solution _(requires C# .NET development expertise)_ or by
- manually downloading pre-built binary package and extracting it into a desired work directory _(link for download sent via email)_

## Usage

### First time run
* Run the application by executing the `bank-statements-parser.exe` binary file _(or a shortcut pointing to it)_
    * This will initialize the system and create a default work directory structure and a config file located at `c:/YellowNET` and then simply exit.
* Locate the config file `appsettings.json` and open it in `notepad`
* Disable `TestRunMode` setting _(change its value from `true` to `false`)_ - this will disable the "First time run" behavior.

### Later run
When the application is executed the second time it will then start the main process workflow:
- locates all bank statement documents in the following folders:
    - `c:/YellowNET/TatraBanka`
    - _(WIP)_ `c:/YellowNET/SlovenskaPosta`
    - _(WIP)_ `c:/YellowNET/VUB`
- parses each document in the defined folders
- converts each document into a `.csv` version in `c:/YellowNET/Output`
- additionally creates a merged `.csv` version for easier import

## Logging
The application logs every step it performs onto the console output and a log file located at `c:/YellowNET/app.log` which can be opened with `notepad`.

## Remarks
The application flow ignores any `outgoing` payments.