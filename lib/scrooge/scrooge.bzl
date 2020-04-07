SCRIPT_CONTENT = """
#!/usr/bin/env bash

set -ex

bazel-out/host/bin/scrooge_test/scrooge_generator -v --finagle $@

jar -cvf $OUTPUT_JAR com
"""
def _scrooge_gen_impl(ctx):
    output_jar = ctx.actions.declare_file("%s.srcjar" % ctx.label.name)

    ctx.actions.run_shell(
        outputs = [output_jar],
        inputs = ctx.files.thrift_files,
        tools = [ ctx.attr.scrooge_binary.files_to_run.executable ],
        command = SCRIPT_CONTENT,
        arguments = [file.path for file in ctx.files.thrift_files],
        env = {
            "OUTPUT_JAR": output_jar.path,
        }
    )

    return [DefaultInfo(files = depset([output_jar]))]

scrooge_gen = rule(
    implementation = _scrooge_gen_impl,
    attrs = {
        "scrooge_binary": attr.label(
            executable = True,
            providers = [JavaInfo],
            cfg = "host",
        ),
        "thrift_files": attr.label_list(allow_files = True, allow_empty = False),
    },
)