{{ ansible_managed | comment }}

{% if instance.java_opts is defined %}
{% for java_opt in instance.java_opts %}
{{ java_opt.name }}="{{ java_opt.value }}"
{% endfor %}
{% endif %}

{% if instance.xmx is defined %}
JAVA_OPTS="-Xmx{{ instance.xmx }} ${JAVA_OPTS}"
{% else %}
JAVA_OPTS="-Xmx{{ tomcat_xmx }} ${JAVA_OPTS}"
{% endif %}

{% if instance.xms is defined %}
JAVA_OPTS="-Xms{{ instance.xms }} ${JAVA_OPTS}"
{% else %}
JAVA_OPTS="-Xms{{ tomcat_xms }} ${JAVA_OPTS}"
{% endif %}

