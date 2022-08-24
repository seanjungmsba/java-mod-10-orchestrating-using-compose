control 'Application Container' do
  impact 'critical'
  title 'Application service named "spring-boot-compose" running correctly'
  desc 'The application container is running with the correct configuration'

  describe docker.containers.where { names =~ /spring-boot-compose/ && image == 'rest-service-complete:0.0.1-SNAPSHOT' && ports =~ /0.0.0.0:8080/ } do
    its('status') { should match [/Up/] }
  end
  describe http('http://spring-boot-compose:8080/') do
    its('status') { should eq 404 }
  end
end

control 'Postgres Master Running' do
  impact 'critical'
  title 'Postgres Master service named "postgres-compose-master-1" is running'
  desc 'The Postgres RepMgr image is pulled, and a Master instance is running with the correct configuration'

  describe docker.images.where { repository == 'bitnami/postgresql-repmgr' && tag == '14.4.0-debian-11-r9' } do
    it { should exist }
  end
  describe docker.containers.where { names =~ /postgres-compose-master-1/ && image == 'bitnami/postgresql-repmgr:14.4.0-debian-11-r9' } do
    its('status') { should match [/Up/] }
  end
  describe postgres_session('postgres', 'mysecretpassword', 'postgres-compose-master-1', 5432).query('SELECT datname FROM pg_database;') do
    its('output') { should include 'db_test' }
  end
end

control 'Postgres Replica 1 Running' do
  impact 'critical'
  title 'Postgres Replica 1 service named "postgres-compose-replica-1" is running'
  desc 'A Postgres Replica instance is running with the correct configuration'

  describe docker.containers.where { names =~ /postgres-compose-replica-1/ && image == 'bitnami/postgresql-repmgr:14.4.0-debian-11-r9' } do
    its('status') { should match [/Up/] }
  end
  describe postgres_session('postgres', 'mysecretpassword', 'postgres-compose-replica-1', 5432).query('SELECT datname FROM pg_database;') do
    its('output') { should include 'db_test' }
  end
end

control 'Postgres Replica 2 Running' do
  impact 'critical'
  title 'Postgres Replica 2 service named "postgres-compose-replica-2" is running'
  desc 'A Postgres Replica instance is running with the correct configuration'

  describe docker.containers.where { names =~ /postgres-compose-replica-2/ && image == 'bitnami/postgresql-repmgr:14.4.0-debian-11-r9' } do
    its('status') { should match [/Up/] }
  end
  describe postgres_session('postgres', 'mysecretpassword', 'postgres-compose-replica-2', 5432).query('SELECT datname FROM pg_database;') do
    its('output') { should include 'db_test' }
  end
end

control 'PgPoolII Running' do
  impact 'critical'
  title 'PgPoolII service named "pgpool-compose" is running'
  desc 'The PgPoolII instance is pulled and running with the correct configuration'

  describe docker.images.where { repository == 'bitnami/pgpool' && tag == '4.3.2-debian-11-r16' } do
    it { should exist }
  end
  describe docker.containers.where { names =~ /pgpool-compose/ && image == 'bitnami/pgpool:4.3.2-debian-11-r16' } do
    its('status') { should match [/Up/] }
  end
  describe postgres_session('postgres', 'mysecretpassword', 'pgpool-compose', 5432).query('SELECT datname FROM pg_database;') do
    its('output') { should include 'db_test' }
  end
end

control 'PgPoolII Nodes Connected' do
  impact 'critical'
  title 'PgPoolII Backend Nodes Online'
  desc 'The PgPoolII instance is running, and all the backend nodes are detected'

  describe postgres_session('postgres', 'mysecretpassword', 'pgpool-compose', 5432).query('SHOW POOL_NODES;') do
    its('output') { should match('postgres-compose-master-1').and match('postgres-compose-replica-1').and match('postgres-compose-replica-2') }
  end
end
