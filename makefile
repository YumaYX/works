s:	install
	bundle exec jekyll server -H 0.0.0.0 -P 4003

install:
	bundle install

pub:
	rm index.markdown
	git status
	sleep 5
	git add .
	git commit -am 'update'
	git push

port:
	sudo dnf -y install firewalld
	sudo systemctl restart firewalld
	sudo firewall-cmd --permanent --zone=public --add-port=4003/tcp
	sudo firewall-cmd --reload

