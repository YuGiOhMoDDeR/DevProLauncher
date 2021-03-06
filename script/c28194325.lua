--Heroic Challenger - Clasp Sword
function c28194325.initial_effect(c)
	--ss success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28194325,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28194325.condition)
	e1:SetCost(c28194325.cost)
	e1:SetTarget(c28194325.target)
	e1:SetOperation(c28194325.operation)
	c:RegisterEffect(e1)
end

function c28194325.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x06f) and re:GetHandler():IsType(TYPE_MONSTER)
end

function c28194325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,28194325)==0 end
	Duel.RegisterFlagEffect(tp,28194325,RESET_PHASE+PHASE_END,0,1)
end

function c28194325.filter(c)
	return c:IsSetCard(0x6f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28194325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28194325.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28194325.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28194325.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end