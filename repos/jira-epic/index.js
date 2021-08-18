const fs = require("fs");
const stdinBuffer = fs.readFileSync(0);
main(stdinBuffer.toString());

function main(json) {
	const rawIssues = JSON.parse(json).rss.channel.item

	const issues = rawIssues.map(issue => {
		const id = issue.key['$t'];
		const summary = issue.summary;
		const links = issue.issuelinks?.issuelinktype;
		const outward = asLink(links?.outwardlinks);
		const status = issue.status['$t']
		const isClosed = status == 'Closed'

		return {
			summary,
			id,
			outward,
			isClosed
		}
	})

	console.log("digraph graphname{")

	issues.forEach(({ summary, id, isClosed }) => {
		const extra = isClosed ? " fillcolor=green style=filled" : ""
		console.log(`  "${id}"[label="${summary}"${extra}]`)
	})

	console.log("")

	issues.forEach(({ id, outward }) => {
		if (outward?.target) {
			console.log(`  "${id}"->"${outward.target}" [label="${outward.description}"]`)
		}
	})

	console.log("}")
}

function asLink(x) {
	if (x == null || x == undefined) {
		return null
	}
	return {
		description: x.description,
		target: (x.issuelink?.issuekey || {})['$t']
	}
}