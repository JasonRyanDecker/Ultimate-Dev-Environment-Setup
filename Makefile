# ========================================
# Dev Environment Makefile
# ========================================

SHELL := /bin/bash

help:
	@echo ""
	@echo "Available commands:"
	@echo "  make setup     - Run the full setup script"
	@echo "  make check     - Verify installed versions"
	@echo "  make clean     - Remove test projects"
	@echo ""

setup:
	@chmod +x setup-dev-env.sh
	@./setup-dev-env.sh

check:
	@chmod +x check.sh
	@./check.sh

clean:
	rm -rf ~/Projects/react-starter ~/Projects/next-starter
	@echo "🧹 Cleaned up sample projects!"
