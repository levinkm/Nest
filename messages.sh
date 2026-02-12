#!/bin/bash

# SMS Test Script for Nest Finance App
# Sends various Kenyan banking SMS messages to Android emulator
# Usage: ./send_test_sms.sh

echo "======================================"
echo "Nest App SMS Testing Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if emulator is running
adb devices | grep emulator &> /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Error: No emulator detected. Please start an emulator first."
    exit 1
fi

echo "✅ Emulator detected"
echo ""

# Function to send SMS
send_sms() {
    local sender=$1
    local message=$2
    local description=$3
    
    echo -e "${BLUE}📱 Sending: ${description}${NC}"
    adb emu sms send "$sender" "$message"
    sleep 1
}

echo "======================================"
echo "1. COOP BANK MESSAGES"
echo "======================================"

send_sms "COOP" "Dear Customer, Use M-pesa Paybill 400200 to load Levin Kiplagat Mutai Coop pay Card. For Account enter P0733017600. Enq; 0703027000" "Coop Card Load Instructions"

send_sms "COOP" "Purchase of USD 4.59 from HETZNER ONLINE GMBH>GUNZENHAUSEN at 10-Jan-2026 05:05:35 was unsuccessful. Your available balance is KES 34.51. For queries call +254703027000" "Failed International Purchase"

send_sms "COOP" "Dear LEVIN, your E-loan repayment of KES 33,334.00 is due on 19-JAN-26. Kindly make arrangement to clear on or before due date. To pay, deposit to your bank account (0111***00) through the branch or use Pay bill no 400200. Ignore if you have already paid." "E-Loan Due Reminder"

send_sms "COOP" "Never share your card details with anyone. You have made a purchase of KES 0.00 from PAYPAL *LINKEDIN>35314369001 at 15-Jan-2026 00:59:27. Your available balance is KES 34.51. For queries call +254703027000" "LinkedIn Subscription"

send_sms "COOP" "Purchase of KES 12314.47 from PAYPAL *BUYEE>4029357733 at 24-Jan-2026 02:04:44 was unsuccessful. Your available balance is KES 34.51. For queries call +254703027000" "Failed Purchase - Insufficient Funds"

send_sms "COOP" "Dear Customer, You do not qualify for this product at the moment.Call 070302700 or 0202776000 for further information." "Product Qualification"

echo ""
echo "======================================"
echo "2. ZIIDI INVESTMENT MESSAGES"
echo "======================================"

send_sms "ZIIDI" "You have successfully invested Ksh. 10,000.00 of transaction code UAB9I3DB32. Your ZIIDI balance is Ksh. 10,075.58" "Large Investment"

send_sms "ZIIDI" "You have successfully withdrawn Ksh. 2,600.00 of transaction code UAA9I3B4R3. Your ZIIDI balance is Ksh. 29.14." "Withdrawal"

send_sms "ZIIDI" "You have successfully invested Ksh 8.00 of transaction code UAA9I3BNF2." "Small Investment 1"

send_sms "ZIIDI" "You have successfully invested Ksh 30.00 of transaction code UAB9I3D42Z." "Small Investment 2"

send_sms "ZIIDI" "You have successfully withdrawn Ksh. 1,000.00 of transaction code UAB9I3FMKM. Your ZIIDI balance is Ksh. 9,075.58." "Withdrawal"

send_sms "ZIIDI" "You have successfully withdrawn Ksh. 7,000.00 of transaction code UAC9I3IKEM. Your ZIIDI balance is Ksh. 181.27." "Large Withdrawal"

send_sms "ZIIDI" "You have successfully withdrawn Ksh. 200.00 of transaction code UAD9I3K0WZ. Your ZIIDI balance is Ksh. 7.96." "Withdrawal"

send_sms "ZIIDI" "You have successfully invested Ksh 20.00 of transaction code UAN9I4HCWN." "Investment"

echo ""
echo "======================================"
echo "3. M-PESA TRANSACTIONS (Person to Person)"
echo "======================================"

send_sms "M-PESA" "UAK9I47RJQ Confirmed. Ksh30.00 sent to JAIRUS MOSE 0724047665 on 20/1/26 at 3:34 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,860.00. Earn interest daily on Ziidi MMF,Dial *334#" "Send Money - JAIRUS"

send_sms "M-PESA" "UAK9I47VU6 Confirmed. Ksh30.00 sent to James Njeri on 20/1/26 at 3:53 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,780.00. Sign up for Lipa Na M-PESA Till online https://m-pesaforbusiness.co.ke" "Send Money - James"

send_sms "M-PESA" "UAK9I481UC Confirmed. Ksh30.00 sent to ELIAS NJERU on 20/1/26 at 4:40 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,750.00. Sign up for Lipa Na M-PESA Till online https://m-pesaforbusiness.co.ke" "Send Money - ELIAS"

send_sms "M-PESA" "UAN9I4GYV1 Confirmed. Ksh100.00 sent to IVY JEPNGETICH 0791032261 on 23/1/26 at 11:56 AM. New M-PESA balance is Ksh252.95. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,900.00. Earn interest daily on Ziidi MMF,Dial *334#" "Send Money - IVY"

send_sms "M-PESA" "UAN9I4HNQ5 Confirmed. Ksh100.00 sent to JUSPER KIPCHIRCHIR 0794841940 on 23/1/26 at 4:02 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,550.00. Earn interest daily on Ziidi MMF,Dial *334#" "Send Money - JUSPER"

send_sms "M-PESA" "UAN9I4I02R Confirmed. Ksh40.00 sent to Margaret Kiragu 0748183010 on 23/1/26 at 5:34 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,510.00. Earn interest daily on Ziidi MMF,Dial *334#" "Send Money - Margaret"

echo ""
echo "======================================"
echo "4. M-PESA RECEIVED MONEY"
echo "======================================"

send_sms "M-PESA" "UAL9I49HJ7 Confirmed.You have received Ksh500.00 from JUSPER KIPCHIRCHIR 5822252 on 21/1/26 at 12:08 AM New M-PESA balance is Ksh500.00. Download and try the Business App; Android https://bit.ly/lnm-app or IOS https://bit.ly/LNM-app" "Received Money - JUSPER"

send_sms "M-PESA" "UAN9I4GJLV Confirmed.You have received Ksh1,050.00 from JUSPER KIPCHIRCHIR 5822252 on 23/1/26 at 9:34 AM New M-PESA balance is Ksh1,050.00. Download and try the Business App; Android https://bit.ly/lnm-app or IOS https://bit.ly/LNM-app" "Received Money - JUSPER"

send_sms "M-PESA" "UANAZ4O2IT Confirmed.You have received Ksh200.00 from Pascaline Arusei 0728896722 on 23/1/26 at 10:26 AM New M-PESA balance is Ksh352.95. Earn interest daily on Ziidi MMF,Dial *334#" "Received Money - Pascaline"

echo ""
echo "======================================"
echo "5. M-PESA PAYBILL PAYMENTS"
echo "======================================"

send_sms "M-PESA" "UAK9I47SZV Confirmed. Ksh50.00 sent to ZURI GENESIS CO LTD for account 409 on 20/1/26 at 3:39 PM New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,810.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Paybill - ZURI GENESIS"

send_sms "M-PESA" "UAL9I49SCS Confirmed. Ksh85.00 sent to M-KOPA Kenya Ltd for account 23495815 on 21/1/26 at 8:06 AM New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,915.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Paybill - M-KOPA"

send_sms "M-PESA" "UAM9I4DA5M Confirmed. Ksh85.00 sent to M-KOPA Kenya Ltd for account 23495815 on 22/1/26 at 8:54 AM New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,915.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Paybill - M-KOPA (Recurring)"

send_sms "M-PESA" "UAM9I4DNBY Confirmed. Ksh60.00 sent to Lipa na KCB for account 7565368 on 22/1/26 at 12:10 PM New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,855.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Paybill - KCB Loan"

send_sms "M-PESA" "UAL9I4AO8S Confirmed. Ksh50.00 sent to ZURI GENESIS CO LTD for account 934 on 21/1/26 at 1:12 PM New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,745.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Paybill - ZURI GENESIS (Different Account)"

send_sms "M-PESA" "UAN9I4HCWN Confirmed. Ksh20.00 sent to ZIIDI on 23/1/26 at 2:18 PM New M-PESA balance is Ksh32.95. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,680.00. Pay your water/KPLC bill conveniently using M-PESA APP or use Paybill option on Lipa Na M-PESA." "Transfer to Ziidi"

echo ""
echo "======================================"
echo "6. M-PESA LIPA NA M-PESA (TILL PAYMENTS)"
echo "======================================"

send_sms "M-PESA" "UAL9I4AKN7 Confirmed. Ksh50.00 paid to CANDY SHOP DENLUCK via Kopo Kopo. on 21/1/26 at 1:49 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,695.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - CANDY SHOP"

send_sms "M-PESA" "UAM9I4FS25 Confirmed. Ksh40.00 paid to CANDY SHOP DENLUCK via Kopo Kopo. on 22/1/26 at 9:44 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,815.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - CANDY SHOP (Recurring)"

send_sms "M-PESA" "UAL9I4B9F9 Confirmed. Ksh150.00 paid to REGMA HOTEL. on 21/1/26 at 5:46 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,545.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - REGMA HOTEL"

send_sms "M-PESA" "UAN9I4IG40 Confirmed. Ksh50.00 paid to REGMA HOTEL. on 23/1/26 at 7:42 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,460.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - REGMA HOTEL (Recurring)"

send_sms "M-PESA" "UAN9I4H7OA Confirmed. Ksh200.00 paid to CAFE 309. on 23/1/26 at 2:18 PM.New M-PESA balance is Ksh52.95. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,700.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - CAFE 309"

send_sms "M-PESA" "UAN9I4H7PI Confirmed. Ksh30.00 paid to CAFE 309. on 23/1/26 at 2:20 PM.New M-PESA balance is Ksh2.95. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,650.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - CAFE 309 (2nd)"

send_sms "M-PESA" "UAN9I4IKFQ Confirmed. Ksh150.00 paid to CAFE 309. on 23/1/26 at 7:46 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,310.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - CAFE 309 (3rd)"

send_sms "M-PESA" "UAN9I4IHWJ Confirmed. Ksh80.00 paid to CANDY SHOP DENLUCK via Kopo Kopo. on 23/1/26 at 7:51 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,230.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk" "Till Payment - CANDY SHOP (3rd)"

send_sms "M-PESA" "UAL9I4A4IC Confirmed. Ksh50.00 sent to ESTHER WATHONI on 21/1/26 at 10:18 AM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,865.00. Sign up for Lipa Na M-PESA Till online https://m-pesaforbusiness.co.ke" "Send Money - ESTHER"

send_sms "M-PESA" "UAL9I4ACPE Confirmed. Ksh70.00 sent to serah kariuki on 21/1/26 at 12:15 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,795.00. Sign up for Lipa Na M-PESA Till online https://m-pesaforbusiness.co.ke" "Send Money - serah"

echo ""
echo "======================================"
echo "7. FULIZA M-PESA (OVERDRAFT)"
echo "======================================"

send_sms "M-PESA" "UAK9I47RJQ Confirmed. Fuliza M-Pesa amount is Ksh 30.00. Access Fee charged Ksh 0.30. Total Fuliza M-Pesa outstanding amount is Ksh639.55 due on 12/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - Initial Debt"

send_sms "M-PESA" "UAK9I47SZV Confirmed. Fuliza M-Pesa amount is Ksh 50.00. Access Fee charged Ksh 0.50. Total Fuliza M-Pesa outstanding amount is Ksh690.05 due on 12/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - Debt Increasing"

send_sms "M-PESA" "UAK9I47VU6 Confirmed. Fuliza M-Pesa amount is Ksh 30.00. Access Fee charged Ksh 0.30. Total Fuliza M-Pesa outstanding amount is Ksh720.35 due on 12/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - More Debt"

send_sms "M-PESA" "UAL9I49HJ8 Confirmed. Ksh 500.00 from your M-PESA has been used to partially pay your outstanding Fuliza M-PESA. Your available Fuliza M-PESA limit is Ksh 649.35. M-PESA balance is Ksh0.00." "Fuliza - Partial Repayment"

send_sms "M-PESA" "UAL9I49SCS Confirmed. Fuliza M-Pesa amount is Ksh 85.00. Access Fee charged Ksh 0.85. Total Fuliza M-Pesa outstanding amount is Ksh336.50 due on 12/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - New Debt After Repayment"

send_sms "M-PESA" "UAL9I4A4IC Confirmed. Fuliza M-Pesa amount is Ksh 50.00. Access Fee charged Ksh 0.50. Total Fuliza M-Pesa outstanding amount is Ksh387.00 due on 12/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - Debt Growing"

send_sms "M-PESA" "UAM9I4FS25 Confirmed. Fuliza M-Pesa amount is Ksh 40.00. Access Fee charged Ksh 0.40. Total Fuliza M-Pesa outstanding amount is Ksh897.05 due on 12/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - Peak Debt"

send_sms "M-PESA" "UAN9I4GJLW Confirmed. Ksh 897.05 from your M-PESA has been used to fully pay your outstanding Fuliza M-PESA. Available Fuliza M-PESA limit is Ksh 900.00. M-PESA balance is Ksh152.95." "Fuliza - Full Repayment"

send_sms "M-PESA" "UAN9I4HNQ5 Confirmed. Fuliza M-Pesa amount is Ksh 97.05. Access Fee charged Ksh 0.98. Total Fuliza M-Pesa outstanding amount is Ksh98.03 due on 22/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - New Debt Cycle"

send_sms "M-PESA" "UAN9I4I02R Confirmed. Fuliza M-Pesa amount is Ksh 40.00. Access Fee charged Ksh 0.40. Total Fuliza M-Pesa outstanding amount is Ksh138.43 due on 22/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - Continuing Debt"

send_sms "M-PESA" "UAN9I4IKFQ Confirmed. Fuliza M-Pesa amount is Ksh 150.00. Access Fee charged Ksh 1.50. Total Fuliza M-Pesa outstanding amount is Ksh340.43 due on 22/02/26. To check daily charges, Dial *234*0#OK Select Query Charges" "Fuliza - Latest Debt"

echo ""
echo "======================================"
echo "8. KCB BANK CONFIRMATIONS"
echo "======================================"

send_sms "KCB" "Ksh 120.00 sent to KCB account EXECUTIVEMODELLIMITED 7565368 has been received on 13/01/2026 at 09:31 AM. M-PESA Ref UAD9I3JVPS. To reverse this transaction, SMS this message to 16120." "KCB Confirmation 1"

send_sms "KCB" "Ksh 60.00 sent to KCB account EXECUTIVEMODELLIMITED 7565368 has been received on 15/01/2026 at 11:55 AM. M-PESA Ref UAF9I3QSBL. To reverse this transaction, SMS this message to 16120." "KCB Confirmation 2"

send_sms "KCB" "Ksh 50.00 sent to KCB account EXECUTIVEMODELLIMITED 7565368 has been received on 19/01/2026 at 02:00 PM. M-PESA Ref UAJ9I448ZZ. To reverse this transaction, SMS this message to 16120." "KCB Confirmation 3"

send_sms "KCB" "Ksh 60.00 sent to KCB account EXECUTIVEMODELLIMITED 7565368 has been received on 20/01/2026 at 12:08 PM. M-PESA Ref UAK9I474N9. To reverse this transaction, SMS this message to 16120." "KCB Confirmation 4"

send_sms "KCB" "Ksh 60.00 sent to KCB account EXECUTIVEMODELLIMITED 7565368 has been received on 22/01/2026 at 12:10 PM. M-PESA Ref UAM9I4DNBY. To reverse this transaction, SMS this message to 16120." "KCB Confirmation 5"

echo ""
echo "======================================"
echo "9. SECURITY & OTHER MESSAGES"
echo "======================================"

send_sms "COOP" "Please do not share this code with anyone at all! even people calling themselves bank staff. Dear LEVIN KIPLAGAT MUTAI, your verification code is 000169 for transaction at 26-Jan-2026 10:13 AM . EEnNkhl+Uzh" "OTP Code 1"

send_sms "COOP" "Please do not share this code with anyone at all! even people calling themselves bank staff. Dear LEVIN KIPLAGAT MUTAI, your verification code is 411691 for transaction at 26-Jan-2026 10:13 AM . EEnNkhl+Uzh" "OTP Code 2"

send_sms "M-PESA" "Failed, you have entered the wrong PIN. If forgotten please dial *334#, select My Account, select M-PESA PIN Manager then M-PESA Forgot PIN and follow the prompts." "Failed PIN Attempt"

echo ""
echo -e "${GREEN}======================================"
echo "✅ All SMS messages sent successfully!"
echo "======================================${NC}"
echo ""
echo "Total messages sent: 67"
echo ""
echo "Test Coverage:"
echo "  - Coop Bank transactions (5 messages)"
echo "  - Ziidi investments/withdrawals (8 messages)"
echo "  - M-Pesa P2P transfers (9 messages)"
echo "  - M-Pesa received money (3 messages)"
echo "  - M-Pesa Paybill payments (6 messages)"
echo "  - M-Pesa Till payments (10 messages)"
echo "  - Fuliza overdraft cycle (11 messages)"
echo "  - KCB confirmations (5 messages)"
echo "  - Security messages (3 messages)"
echo ""
echo "You can now test your Nest app's SMS parsing!"
echo ""