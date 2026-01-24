package util

import "net/url"

func IsValidURL(toTest string) bool {
	url, err := url.ParseRequestURI(toTest)
	return err == nil && (url.Scheme == "http" || url.Scheme == "https") && url.Host != "" && url.Path != ""
}
