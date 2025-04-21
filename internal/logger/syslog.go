package logger

import (
	"log/slog"
	"log/syslog"
)

type SyslogHander struct {
	writer *syslog.Writer
	attrs  []slog.Attr
}
