function statusCheck() {
	if (document.location.protocol == "file:") {
		console.warn("file protocol, doing nothing");
		return;
	}
	var to = setTimeout(function() {
		statusCheck();
	}, 5000);
	var titleNode = document.getElementById('title');
	var lastStatus = parseInt(titleNode.textContent);

	var contentNode = document.getElementById('content');
	var messageNode = document.getElementById('message');
	var xhr = new XMLHttpRequest();
	xhr.open("GET", "/.well-known/status", true);
	xhr.onreadystatechange = function() {
		if (this.readyState != 4) return;
		var code = this.status;
		if (code === lastStatus) return;
		if (code >= 200 && code < 300) {
			var res;
			try {
				res = JSON.parse(this.responseText);
			} catch(ex) {
				return;
			}
			if (res.errors && res.errors.length) {
				display(null, 'Error installing site', res.errors.map(function(line) {
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
				display(code, "Reloading...", false, 'Redirecting to<br><a href="' + encodeURI(loc) + '">' + loc + '</a>', "");
				clearTimeout(to);
				setTimeout(function() {
					document.location.reload();
				}, 500);
				return;
			}
		} else if (code == 400) {
			display(code, "Bad request", false, "Please check the address");
		} else if (code == 404) {
			display(code, "Site not found", false, "Please check the address");
		} else {
			if (code == 0) {
				display(code, "Request error", true, "Server is unreachable");
			} else if (code == 501 || code == 502 || code == 503) {
				display(code, " Maintenance", true, "please wait<br>the page will open automatically in a moment");
			} else {
				display(code, "error", false, "unknown error - please report this incident");
			}
		}
	};
	try {
		xhr.send();
	} catch(ex) {
		display(0, "Network error", "Please contact administrator");
	}
	function display(code, title, content, message) {
		if (title != null) titleNode.innerHTML = (code ? code + ' ' : '') + title;
		if (content === false) {
			contentNode.firstElementChild.hidden = true;
		} else if (content === true) {
			contentNode.firstElementChild.hidden = false;
		} else if (content != null) {
			contentNode.innerHTML = content;
		}
		if (message != null) messageNode.innerHTML = message;
	}
}

if (document.readyState === 'complete') statusCheck();
else window.onload = statusCheck;

