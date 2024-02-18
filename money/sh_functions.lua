local META = FindMetaTable("Player")

function META:GetMoney()
    return self:GetNWInt("money")
end

function formatMoney(amount)
    local formattedAmount = string.format("%d", amount)
    local reverseAmount = string.reverse(formattedAmount)
    local formattedMoney = string.gsub(reverseAmount, "(%d%d%d)", "%1,")
    
    return "$" .. string.reverse(formattedMoney)
end