require! <[ util express formidable ]>
app = express!
app
	..route '*'
	.all (req, res, next)-> # parse data
		if req.method.toLowerCase! in ['post','put','patch','delete']
			form = new formidable.IncomingForm!
			form.hash = \md5
			form.multiples = true
			# err, fields, files <- form.parse req
			form.parse req, (err, fields, files)->
				if err?
					process.winston.error 'login:formidable '+err
					res.status 500 .send 'upload error.'
				else
					req.fields = fields
					req.files = files
					console.log 'parsed.'
			form.on 'end', ->
				next!
		else
			next!
	..route '/'
	.get (req, res, next)->
		res.send """<html>
			<body>
				<form enctype="multipart/form-data" method='POST' action='/upload'>
					<input type="text" name="title"><br />
					<input type='file' name='asdf' multiple="multiple" /><br />
					<input type='submit' />
				</form><br />
				<form method='POST' action='/upload'>
					<input type='submit' />
				</form>
			</body>
		</html>"""
	..route '/upload'
	.post (req, res, next)->
		console.log util.inspect req.files
		console.log util.inspect req.fields
		if req.files.length < 0
			console.log 'files not null'
			res.send 'files not null'
		else
			res.send 'no files'

app.listen 9090
