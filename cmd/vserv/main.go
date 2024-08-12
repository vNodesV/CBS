package main

import (
	"github.com/vNodesV/vServ/pkg/vserv/config"
	"github.com/vNodesV/vServ/pkg/vserv/katch"
)

func main() {
	config.LoadConfig()  // Load configuration
	katch.RunSetup()     // Setup kAtch
	katch.RunConnector() // Run kAtch connector
	// Add additional vServ functionalities here
}
