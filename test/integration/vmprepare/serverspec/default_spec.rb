require 'serverspec'
require 'spec_helper'

describe 'eas2 vm preparation' do
    describe user('eas2') do
      it { should exist }
      it { should belong_to_group 'as2' }
      it { should have_home_directory '/as2/eas2' }
    end
    
    describe group('as2') do
      it { should exist }
    end


    describe file('/as2/eas2') do
        it { should exist }
        it { should be_directory }
        it { should be_mode 755 }
        it { should be_owned_by 'eas2' }
    end
end
