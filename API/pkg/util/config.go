package util

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v3"
)

func LoadConfig(filename string, config interface{}) error {
	path := fmt.Sprintf("./config/%s", filename)
	if _, err := os.Stat(path); os.IsNotExist(err) {
		path = fmt.Sprintf("./%s", filename)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			path = fmt.Sprintf("/srv/kyber-api/config/%s", filename)
		}
	}

	if _, err := os.Stat(path); os.IsNotExist(err) {
		// Log warning but return nil to prevent panics
		fmt.Printf("Warning: Config file %s not found, using defaults\n", filename)
		return nil
	}

	file, err := os.Open(path)
	if err != nil {
		return err
	}

	defer file.Close()

	if err := yaml.NewDecoder(file).Decode(config); err != nil {
		return err
	}

	return nil
}
