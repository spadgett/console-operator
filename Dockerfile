FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
# create a work dir and copy local files in
WORKDIR /go/src/github.com/openshift/console-operator
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
RUN useradd console-operator
USER console-operator
COPY --from=builder /go/src/github.com/openshift/console-operator/_output/local/bin/linux/amd64/console /usr/bin/console

# these manifests are necessary for the installer
COPY manifests /manifests/

LABEL io.k8s.display-name="OpenShift console-operator" \
      io.k8s.description="This is a component of OpenShift Container Platform and manages the lifecycle of the web console." \
      io.openshift.tags="openshift" \
      maintainer="Benjamin A. Petersen <bpetersen@redhat.com>"

LABEL io.openshift.release.operator true

# entrypoint specified in 03-operator.yaml as `console-operator`
# CMD ["/usr/bin/console", "operator", "--kubeconfig", "path/to/config", "--config", "./install/config.yaml", "--v", "4"]
# CMD ["/usr/bin/console", "operator", "--v", "4"]


