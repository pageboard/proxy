project = pageboard

.PHONY: restart
restart:
	systemctl --user stop nginx.service
	systemctl --user stop memcached.service
	systemctl --user restart pageboard.service
	systemctl --user start memcached.service
	systemctl --user start nginx.service

.PHONY: enable
enable:
	systemctl --user enable $(PWD)/pageboard@.service
	systemctl --user enable $(PWD)/pageboard.service
	systemctl --user enable $(PWD)/pageboard-reload.service
	systemctl --user enable $(PWD)/pageboard-reload.timer
	systemctl --user enable $(PWD)/memcached.service
	systemctl --user enable $(PWD)/nginx.service
	systemctl --user enable $(PWD)/nginx-reload.service
	systemctl --user enable $(PWD)/nginx-reload.timer

.PHONY: disable
disable: stop
	systemctl --user disable pageboard@.service
	systemctl --user disable pageboard.service
	systemctl --user disable pageboard-reload.service
	systemctl --user disable pageboard-reload.timer
	systemctl --user disable memcached.service
	systemctl --user disable nginx.service
	systemctl --user disable nginx-reload.service
	systemctl --user disable nginx-reload.timer

.PHONY: stop
stop:
	systemctl --user stop nginx-reload.service
	systemctl --user stop nginx-reload.timer
	systemctl --user stop nginx.service
	systemctl --user stop memcached.service
	systemctl --user stop pageboard-reload.service
	systemctl --user stop pageboard-reload.timer
	systemctl --user stop pageboard.service

.PHONY: start
start:
	systemctl --user start pageboard.service
	systemctl --user start pageboard-reload.timer
	systemctl --user start pageboard-reload.service
	systemctl --user start memcached.service
	systemctl --user start nginx.service
	systemctl --user start nginx-reload.timer
	systemctl --user start nginx-reload.service

