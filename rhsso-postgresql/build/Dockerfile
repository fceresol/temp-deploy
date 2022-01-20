FROM registry.redhat.io/rh-sso-7/sso75-openshift-rhel8

MAINTAINER <Filippo Ceresoli> <filippo.ceresoli@redhat.com>

ENV DEFAULT_LAUNCH $JBOSS_HOME/bin/openshift-launch.sh

COPY extensions/*.sh    $JBOSS_HOME/extensions/
COPY extensions/*.cli         $JBOSS_HOME/extensions/


USER root
RUN chmod 774 $JBOSS_HOME/extensions/*.sh
USER jboss

CMD $DEFAULT_LAUNCH
