require 'serverspec'
require 'spec_helper'
 
describe 'eas2 reallocate' do
    describe cron do
        it { should have_entry('* * * * * /ib/mbin/EDI_EAS2/as2_host/scripts/reallocate.ctb GLOBAL /ib/mbin/EDI_EAS2/cfg 2>&1 | /ib/sw/ediscripts/logToEdistart.pl /as2/eas2/crontab/log').with_user('eas2') }
    end

    describe user('eas2') do
        it { should have_login_shell '/bin/ksh' }
    end

end
