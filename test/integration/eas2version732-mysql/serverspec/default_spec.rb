require 'serverspec'
require 'spec_helper'

describe 'eas2' do
    describe file('/as2/eas2/e-AS2') do
        it { should be_symlink }
    end

    describe port(5080) do
        it { should be_listening }
    end 
    
    describe port(5090) do
        it { should be_listening }
    end 

    describe cron do
        it { should have_entry('25 01,04,07,10,13,16,19,22 * * * /as2/eas2/scripts/purge.ctb /as2/interface/in_mdn/ \'*\' 30 2>&1 | /ib/sw/ediscripts/logToEdistart.pl /as2/eas2/crontab/log').with_user('eas2') }
    end

    describe cron do
        it { should have_entry('25 01,04,07,10,13,16,19,22 * * * /as2/eas2/scripts/purge.ctb /as2/interface/in/_done_/ \'*\' 2 2>&1 | /ib/sw/ediscripts/logToEdistart.pl /as2/eas2/crontab/log').with_user('eas2') }
    end

    describe cron do
        it { should have_entry('25 01,04,07,10,13,16,19,22 * * * /as2/eas2/scripts/purge.ctb /as2/interface/in/_errors_/ \'*\' 30 2>&1 | /ib/sw/ediscripts/logToEdistart.pl /as2/eas2/crontab/log').with_user('eas2') }
    end

    describe cron do
        it { should have_entry('25 01,04,07,10,13,16,19,22 * * * /as2/eas2/scripts/purge.ctb.new "/as2/interface/out/*/_errors_/" \'*\' 30 2>&1 | /ib/sw/ediscripts/logToEdistart.pl /as2/eas2/crontab/log').with_user('eas2') }
    end

    describe file('/as2log/eas2s.log') do
        its(:content) { should match /accessing database via MySQL Connector Java/ }
    end

    describe file('/as2log/eas2s.log') do
        its(:content) { should_not match /ERROR/ }
    end

    describe file('/as2log/eas2s.log') do
        its(:content) { should_not match /FATAL/ }
    end

    describe file('/as2log/eas2s.log') do
        its(:content) { should match /license is OK/ }
    end

    describe user('eas2') do
        it { should have_login_shell '/bin/ksh' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.port' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.cert' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.clientauth' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.port.2' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.cert.2' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.clientauth.2' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.port.3' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.cert.3' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.clientauth.3' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.port.4' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.cert.4' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'connection.https.clientauth.4' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'mail.host' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'mail.to' }
    end

    describe file('/as2/eas2/e-AS2/EAS2.properties') do
        it { should_not contain 'mail.from' }
    end

end
