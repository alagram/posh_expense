require 'spec_helper'

describe Item do
 it { should belong_to(:shop) }
end
