# Surefire Plugin Failure in Alpine JDK11 Docker Container

Link to StackOverflow question: https://stackoverflow.com/questions/54716967/maven-tests-fail-with-forked-vm-terminated-in-docker

## Steps to Reproduce

Build and run the container:

```
docker build -t so-demo .
docker run so-demo
```

See test failure:

```
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 0, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  8.000 s
[INFO] Finished at: 2019-02-15T20:04:24Z
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-surefire-plugin:3.0.0-M3:test (default-test) on project so-demo: There are test failures.
[ERROR] 
[ERROR] Please refer to /app/target/surefire-reports for the individual test results.
[ERROR] Please refer to dump files (if any exist) [date].dump, [date]-jvmRun[N].dump and [date].dumpstream.
[ERROR] The forked VM terminated without properly saying goodbye. VM crash or System.exit called?
[ERROR] Command was /bin/sh -c cd /app && /opt/java/openjdk/bin/java -jar /app/target/surefire/surefirebooter15847623166706412603.jar /app/target/surefire 2019-02-15T20-04-23_904-jvmRun1 surefire15681748693720284143tmp surefire_01815807763590795362tmp
[ERROR] Error occurred in starting fork, check output in log
[ERROR] Process Exit Code: 1
[ERROR] org.apache.maven.surefire.booter.SurefireBooterForkException: The forked VM terminated without properly saying goodbye. VM crash or System.exit called?
[ERROR] Command was /bin/sh -c cd /app && /opt/java/openjdk/bin/java -jar /app/target/surefire/surefirebooter15847623166706412603.jar /app/target/surefire 2019-02-15T20-04-23_904-jvmRun1 surefire15681748693720284143tmp surefire_01815807763590795362tmp
[ERROR] Error occurred in starting fork, check output in log
[ERROR] Process Exit Code: 1
[ERROR] 	at org.apache.maven.plugin.surefire.booterclient.ForkStarter.fork(ForkStarter.java:670)
[ERROR] 	at org.apache.maven.plugin.surefire.booterclient.ForkStarter.run(ForkStarter.java:283)
[ERROR] 	at org.apache.maven.plugin.surefire.booterclient.ForkStarter.run(ForkStarter.java:246)
[ERROR] 	at org.apache.maven.plugin.surefire.AbstractSurefireMojo.executeProvider(AbstractSurefireMojo.java:1161)
[ERROR] 	at org.apache.maven.plugin.surefire.AbstractSurefireMojo.executeAfterPreconditionsChecked(AbstractSurefireMojo.java:1002)
[ERROR] 	at org.apache.maven.plugin.surefire.AbstractSurefireMojo.execute(AbstractSurefireMojo.java:848)
[ERROR] 	at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:137)
[ERROR] 	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
[ERROR] 	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
[ERROR] 	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
[ERROR] 	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
[ERROR] 	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
[ERROR] 	at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
[ERROR] 	at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
[ERROR] 	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
[ERROR] 	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
[ERROR] 	at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
[ERROR] 	at org.apache.maven.cli.MavenCli.execute(MavenCli.java:956)
[ERROR] 	at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
[ERROR] 	at org.apache.maven.cli.MavenCli.main(MavenCli.java:192)
[ERROR] 	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
[ERROR] 	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
[ERROR] 	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
[ERROR] 	at java.base/java.lang.reflect.Method.invoke(Method.java:566)
[ERROR] 	at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:289)
[ERROR] 	at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:229)
[ERROR] 	at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:415)
[ERROR] 	at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:356)
[ERROR] 
[ERROR] -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException
```

There is only one file generated in `target/surefire-reports`:

```
/app/target/surefire-reports # cat 2019-02-15T20-04-23_904.dumpstream 
# Created at 2019-02-15T20:04:24.258
Error: Invalid or corrupt jarfile /app/target/surefire/surefirebooter15847623166706412603.jar
```

## Observations and Workarounds

### 1. Disabling Forking

This error does not occur if the JVM forking behavior of Surefire is disabled:

```xml
<plugin>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0-M3</version>
    <configuration>
        <forkCount>0</forkCount>
    </configuration>
</plugin>
```

However, disabling forking is undesirable for the isolation (and speed) benefits it provides.

### 2. Using a Different Docker Image

The Alpine Docker image used in the example is [adoptopenjdk/openjdk11:jdk-11.0.2.9-alpine](https://hub.docker.com/r/adoptopenjdk/openjdk11/), which reproduces the issue.

However, switching the Docker image to an Ubuntu-based one (e.g. [adoptopenjdk/maven-openjdk11:latest](https://hub.docker.com/r/adoptopenjdk/maven-openjdk11/) makes the error go away. See modified Dockerfile in `ubuntu-docker/Dockerfile`.

But perhaps most shocking is that switching to Azul Zulu OpenJDK image _still based on Alpine Linux_ [azul/zulu-openjdk-alpine:11](https://hub.docker.com/r/azul/zulu-openjdk-alpine) also makes the problem go away.

### 3. Disabling System Class Loader in Surefire Plugin

Another workaround for this issue, suggested in [carlossg/docker-maven#90](https://github.com/carlossg/docker-maven/issues/90), is to not use the system classloader of `maven-surefire-plugin`. Per their advice, the following configuration

```xml
<plugin>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0-M3</version>
    <configuration>
        <useSystemClassLoader>false</useSystemClassLoader>
    </configuration>
</plugin>
```
    
helps to remedy the Surefire failure.
