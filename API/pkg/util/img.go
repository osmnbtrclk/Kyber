package util

import (
	"crypto/md5"
	"encoding/hex"
	_ "image/jpeg"
)

func GenerateImageHash(target []byte) (string, error) {
	sum := md5.Sum(target)

	return hex.EncodeToString(sum[:]), nil
}
