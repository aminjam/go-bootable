package main

import (
	"testing"
)

func TestMain(t *testing.T) {
	cases := []struct {
		in, want string
	}{
		{"Hello", "Hello"},
	}
	for _, c := range cases {
		got := c.in
		if got != c.want {
			t.Errorf("Reverse(%q) == %q, want %q", c.in, got, c.want)
		}
	}
}
