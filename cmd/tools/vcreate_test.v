import os

const test_path = 'vcreate_test'

fn test_v_init() ? {
	dir := os.join_path(os.temp_dir(), test_path)
	os.rmdir_all(dir) or {}
	os.mkdir(dir) ?
	defer {
		os.rmdir_all(dir) or {}
	}
	os.chdir(dir)

	vexe := os.getenv('VEXE')
	os.execute_or_panic('$vexe init')

	assert os.read_file('vcreate_test.v') ? == [
		'module main\n',
		'fn main() {',
		"	println('Hello World!')",
		'}',
		'',
	].join('\n')

	assert os.read_file('v.mod') ? == [
		'Module {',
		"	name: 'vcreate_test'",
		"	description: ''",
		"	version: ''",
		"	license: ''",
		'	dependencies: []',
		'}',
		'',
	].join('\n')

	assert os.read_file('.gitignore') ? == [
		'# Binaries for programs and plugins',
		'main',
		'vcreate_test',
		'*.exe',
		'*.exe~',
		'*.so',
		'*.dylib',
		'*.dll',
		'',
	].join('\n')
}
