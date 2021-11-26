linklist = linklist.server
linked = $(shell find ~ -type l -exec readlink -f {} \; | grep '.dotfiles')

link:
	./install $(linklist)
	echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.zshenv_bis

zsh:
	rm -rf /tmp/zsh-bin
	mkdir /tmp/zsh-bin
	wget -O /tmp/zsh-bin/install https://raw.githubusercontent.com/romkatv/zsh-bin/master/install
	sh /tmp/zsh-bin/install -d ~/.local -e no

tree:
	rm -rf /tmp/tree-src
	mkdir /tmp/tree-src
	wget -q -O- "http://mama.indstate.edu/users/ice/tree/src/tree-1.8.0.tgz" \
	  | tar --strip-components 1 -C /tmp/tree-src --strip=1 -x -z
	cd /tmp/tree-src && make install prefix=~/.local

htop:
	rm -rf /tmp/htop-src
	mkdir /tmp/htop-src
	wget -q -O- "https://github.com/htop-dev/htop/archive/refs/tags/3.1.1.tar.gz" \
	  | tar --strip-components 1 -C /tmp/htop-src --strip=1 -x -z
	cd /tmp/htop-src && ./autogen.sh && ./configure --prefix=$$HOME/.local && make install

clean:
	@for l in $$(find ~ -type l); do \
	  target=$$(readlink -f "$$l"); \
	  if ! echo $$l | grep -q "$$(basename $$PWD)" && echo $$target | grep -q "$$(basename $$PWD)"; then \
	    echo 'removing:' $$l "->" $$(readlink -f "$$l"); \
	    rm -rf "$$l"; \
	  fi \
	done
	rm -rf ~/.local

.PHONY: clean
