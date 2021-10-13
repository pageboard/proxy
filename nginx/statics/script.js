function statusCheck() {
	if (document.location.protocol == "file:") {
		console.warn("file protocol, doing nothing");
		return;
	}
	var titleNode = document.getElementById('title');
	if (!titleNode) return setTimeout(statusCheck, 100);
	var contentNode = document.getElementById('content');
	var messageNode = document.getElementById('message');
	var xhr = new XMLHttpRequest();
	xhr.open("GET", "/.well-known/status", true);
	xhr.onreadystatechange = function() {
		if (this.readyState != 4) return;
		var code = this.status;
		if (code >= 200 && code < 300) {
			var res;
			try {
				res = JSON.parse(this.responseText);
			} catch(ex) {
				setTimeout(function() {
					window.statusCheck();
				}, 1000);
				return;
			}
			if (res.errors && res.errors.length) {
				display('Error installing site', res.errors.map(function(line) {
					if (typeof line == "string") line = {error: line};
					var str = Object.keys(line).map(function(key) {
						var val = line[key];
						if (typeof val != "string") val = JSON.stringify(val);
						return '<tr><td>' + key + "</td><td><pre>" + val + "</pre></td></tr>";
					}).join('');
					return '<table>' + str + '</table>';
				}).join('\n'));
			} else {
				var loc = document.location.toString();
				display(null, null, 'Redirecting to<br><a href="' + encodeURI(loc) + '">' + loc + '</a>', "");
				setTimeout(function() {
					document.location.reload();
				}, 500);
				return;
			}
		} else if (code == 404) {
			display("Site not found", "Please check the address");
		} else {
			if (code == 0) {
				display("Request error", null, "Either you lost internet access or the server is temporarily down");
			} else if (code == 501 || code == 502 || code == 503) {
				display("Maintenance", null, "please wait<br>the page will open automatically in a moment");
			} else {
				display("Server error", "this incident has been reported");
			}
			setTimeout(function() {
				statusCheck();
			}, 5000);
		}
	};
	try {
		xhr.send();
	} catch(ex) {
		display("Network error", "Please contact administrator");
	}
	function display(title, content, message) {
		if (title != null) titleNode.innerHTML = title;
		if (content != null) contentNode.innerHTML = content;
		if (message != null) messageNode.innerHTML = message;
	}
}
statusCheck();
